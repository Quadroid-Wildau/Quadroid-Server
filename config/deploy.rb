require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require "rvm/capistrano"
# require "delayed/recipes"
load 'deploy/assets'

# multistage
set :stages, %w(staging production)
set :default_stage, "staging"

# Server
role(:web) {"#{server_address}"}                      # Your HTTP server, Apache/etc
role(:app) {"#{server_address}"}                      # This may be the same as your `Web` server
role(:db) { ["#{server_address}", {:primary => true}] } # This is where Rails migrations will run

# Repository
set :application, "quadroid-server"
set :repository,  "git@github.com:Quadroid-Wildau/Quadroid-Server.git"
set :scm, :git
set :deploy_via, :remote_cache
set :keep_releases, 3
ssh_options[:forward_agent] = true

# User
set :use_sudo, false
ENV['USER'] = %x[git config --global user.name].gsub(' ', '_')

# RVM
set :rvm_type, :system
set :rvm_path, "/usr/local/rvm"
set :rvm_bin_path, "/usr/local/rvm/bin"

# delayed job
set :delayed_job_args, "-n 2"

# Tasks
namespace :deploy do

  desc "Symlink shared configs and folders on each release. "
  task :symlink_shared, :roles => :app do
    # database config
    run "touch #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"

    # email config
    # run "touch #{release_path}/config/email.yml"
    # run "ln -nfs #{shared_path}/config/email.yml #{release_path}/config/email.yml"

    # application config
    run "touch #{release_path}/config/application.yml"
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"

    # rvm config
    run "touch #{release_path}/.rvmrc"
    run "ln -nfs #{shared_path}/.rvmrc #{release_path}/.rvmrc"
  end

  task :bundle, :roles => :app do
    run "cd #{release_path} && bundle install"
  end

  task :restart_thin, :roles => :app do
    run "cd #{current_path} && bundle exec thin restart -C #{thin_config}"
  end

  task :start_thin, :roles => :app do
    run "cd #{current_path} && bundle exec thin start -C #{thin_config}"
  end

  task :stop_thin, :roles => :app do
    run "cd #{current_path} && bundle exec thin stop -C #{thin_config}"
  end

  task :setup_rvm, :roles => :app do
    run "source /usr/local/rvm/scripts/rvm && type rvm | head -n 1 && cd #{shared_path} && rvm --create --rvmrc #{rvm_ruby_string}"
  end

  task :install_bundler_gem do
    run "source /usr/local/rvm/scripts/rvm && type rvm | head -n 1 && rvm use #{rvm_ruby_string} && gem install bundler"
  end

end

namespace :notifications do
  task :sample do
    run "cd #{current_path} && bundle exec rake notifications:sample"
  end
end

before 'deploy:setup', 'rvm:create_gemset'
after 'deploy:setup', 'deploy:setup_rvm'
after 'deploy:setup_rvm', 'deploy:install_bundler_gem'

after 'deploy:assets:symlink', 'deploy:symlink_shared'
after 'deploy', 'deploy:restart_thin'

# after "deploy:stop",    "delayed_job:stop"
# after "deploy:start",   "delayed_job:start"
# after "deploy:restart", "delayed_job:restart"

require './config/boot'
