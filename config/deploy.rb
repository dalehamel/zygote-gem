# config valid only for Capistrano 3.1

set :application, 'zygote'
set :repo_url, 'https://github.com/dalehamel/zygote.git'


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }
if ENV.has_key? "REVISION" or ENV.has_key? "BRANCH_NAME"
  set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"]
end

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/u/apps/zygote'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for linked_dirs is []
#set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system config db}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system db}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :sv, 'restart zygote'
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end
