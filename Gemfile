source 'https://rubygems.org'

gem 'genesisreactor', "~> 0.0.2"
#gem 'genesisreactor', :path => '../GenesisReactor'
#gem "genesisreactor", git: "https://github.com/dalehamel/GenesisReactor", ref: 'local-bind'

group :deploy do
  gem "capistrano", "~> 3.4"
  gem "capistrano-bundler"
  gem "capistrano-ejson", git: "https://github.com/Shopify/capistrano-ejson", ref: '51665d2dc7c71a7a3ad19070be993582f19b949b'
end

group :development, :test do
  gem "rspec"
  gem "em-http-request"
  gem 'simplecov'
end
