require 'net/http'
require 'socket'
require 'rspec'
require "em-synchrony"
require "em-synchrony/em-http"
require File.expand_path('../../lib/http.rb', __FILE__)

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

def fixture(name, record: false)
  path = File.expand_path("fixtures/data/#{name}.txt", File.dirname(__FILE__))
  File.read(path)
end

# Returns EventMachine::HttpClient
def get(uri)
  EM::Synchrony.sync(EventMachine::HttpRequest.new(File.join("http://#{Socket.gethostname}:7000/",uri)).aget)
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

