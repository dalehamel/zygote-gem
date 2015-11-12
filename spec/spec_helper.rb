require 'net/http'
require 'socket'
require 'rspec'
require 'yaml'
require 'em-synchrony'
require 'em-synchrony/em-http'
require File.expand_path('../../lib/http.rb', __FILE__)

MOC_PARAMS = YAML.load(File.read(File.expand_path('../../spec/fixtures/params.yml', __FILE__)))
module SynchronySpec
  def self.append_features(mod)
    mod.class_eval %[
      around(:each) do |example|
        EM.synchrony do
          example.run
          EM.stop
        end
      end
    ]
  end
end

def match_fixture(name, actual)
  path = File.expand_path("fixtures/data/#{name}.txt", File.dirname(__FILE__))
  File.open(path, 'w') { |f| f.write(actual) } if ENV['FIXTURE_RECORD']
  expect(actual).to eq(File.read(path))
end

# Returns EventMachine::HttpClient
def get(uri, params={})
  uriq = "#{uri}#{parameterize(params)}"
  EM::Synchrony.sync(EventMachine::HttpRequest.new(File.join("http://#{Socket.gethostname}:7000/", uriq)).aget)
end

def parameterize(params)
  q = URI.escape(params.collect{|k,v| "#{k}=#{v}"}.join('&'))
  q.empty? ? '' : "?#{q}"
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

