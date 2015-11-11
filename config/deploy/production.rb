
set :rails_env, :production

#server 'genesis.ash', user: 'deploy', roles: %w{web app db}
server 'util11.chi.shopify.com', user: 'deploy', roles: %w{web app db}
#server 'bastion1.chi2.shopify.com', port: 2222, user: 'deploy', roles: %w{web app db}
