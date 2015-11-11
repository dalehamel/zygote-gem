require 'genesisreactor'
require 'genesis/protocol/http'
require 'yaml'

include Genesis

class ZygoteWeb < Http::Handler
  CELL_CONFIG = YAML.load(File.read('config/cells.yml')).freeze

  # Requested by iPXE on boot, chains into /boot.
  # This enables us to customize what details we want iPXE to send us
  # The iPXE undionly.kpxe should contain an embedded script to call this URL
  get '/' do
    body {erb :boot }
  end

  get '/chain' do
    #@channel << 'test'
    body {erb :menu, locals: { opts: CELL_CONFIG.merge('params' => params || {}) } }
  end

  get %r{/cell/(?<cell>\w*)/(?<action>\w*)} do
    #@channel << 'test'
    body {erb :"#{params['cell']}/#{params['action']}".to_sym, locals: { opts: CELL_CONFIG.merge('params' => params || {}) } }
  end

#  subscribe do |args|
#    puts args
#  end

end

genesis = Genesis::Reactor.new(
  threads: 1000,
  protocols: {
    Http::Protocol => 8080,
  },
  handlers: [ ZygoteWeb ],
  views: [ File.join(Dir.pwd, 'views'), File.join(Dir.pwd, 'cells') ],
)

genesis.start
