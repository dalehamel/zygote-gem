require 'yaml'
require 'genesisreactor'
require 'genesis/protocol/http'
require 'util'

class ZygoteWeb < Genesis::Http::Handler
  CELL_CONFIG = YAML.load(File.read('config/cells.yml')).freeze

  # Requested by iPXE on boot, chains into /boot.
  # This enables us to customize what details we want iPXE to send us
  # The iPXE undionly.kpxe should contain an embedded script to call this URL
  get '/' do
    body {erb :boot }
  end

  get '/chain' do
    ip = request.ip == "127.0.0.1" ? @env['HTTP_X_FORWARDED_FOR'] : request.ip
    ip = 'unknown' if ENV['TRAVIS'] || ip.nil? || ip.empty?
    cleaned = clean_params(params.to_h)
    cleaned['ip'] = ip
    cleaned['sku'] = compute_sku(cleaned['manufacturer'], cleaned['serial'], cleaned['board-serial'])
    @channel << cleaned
    body {erb :menu, locals: { opts: CELL_CONFIG.merge('params' => cleaned || {}) } }
  end

  get %r{/cell/(?<cell>\w*)/(?<action>\w*)} do
    cleaned = clean_params(params.to_h)
    cell = cleaned['cell']
    cell_opts = CELL_CONFIG['index']['cells'][cell] || {}
    opts = cell_opts.merge('params' => cleaned || {})
    @channel << opts # for debugging
    body {erb :"#{cell}/#{cleaned['action']}".to_sym, locals: { opts: opts } }
  end

  subscribe do |args|
    puts args if ENV['DEBUG']
  end
end

def zygote
  zygote = Genesis::Reactor.new(
    threads: 1000,
    protocols: {
      Genesis::Http::Protocol => 7000,
    },
    handlers: [ ZygoteWeb ],
    views: [ File.join(Dir.pwd, 'views'), File.join(Dir.pwd, 'cells') ],
  )
  zygote
end
