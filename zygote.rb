require 'yaml'
require 'genesisreactor'
require 'genesis/protocol/http'
require_relative 'lib/util'

include Genesis

class ZygoteWeb < Http::Handler
  CELL_CONFIG = YAML.load(File.read('config/cells.yml')).freeze

  # Requested by iPXE on boot, chains into /boot.
  # This enables us to customize what details we want iPXE to send us
  # The iPXE undionly.kpxe should contain an embedded script to call this URL
  get '/' do
    params = clean_params(params || {})
    ip = request.ip == "127.0.0.1" ? @env['HTTP_X_FORWARDED_FOR'] : request.ip
    params['ip'] = ip
    params['sku'] = compute_sku(params['manufacturer'], params['serial'], params['board-serial'])
    @channel << params
    body {erb :boot }
  end

  get '/chain' do
    params = clean_params(params || {})
    body {erb :menu, locals: { opts: CELL_CONFIG.merge('params' => params || {}) } }
  end

  get %r{/cell/(?<cell>\w*)/(?<action>\w*)} do
    cell = params['cell']
    cell_opts = CELL_CONFIG['index']['cells'][cell]
    params = clean_params(params)
    opts = cell_opts.merge('params' => params || {})
    @channel << opts # for debugging
    body {erb :"#{cell}/#{params['action']}".to_sym, locals: { opts: opts } }
  end

  subscribe do |args|
    puts args
  end

end

genesis = Genesis::Reactor.new(
  threads: 1000,
  protocols: {
    Http::Protocol => 7000,
  },
  handlers: [ ZygoteWeb ],
  views: [ File.join(Dir.pwd, 'views'), File.join(Dir.pwd, 'cells') ],
)

genesis.start
