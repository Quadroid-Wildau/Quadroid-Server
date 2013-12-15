set :server_address, "dev.wonderweblabs.com"
set :deploy_to, "/opt/sites/quadroid-server"
set :user, "deploy"
set :branch, "develop"
set :thin_config, '/etc/thin/quadroid-server/config.yml'

# rvm
set :rvm_ruby_string, "ruby-1.9.3-p448@thw-quadroid-server"

# Rails
set :rails_env, "staging"

# bundler
set :bundle_flags, "--deployment --quiet --binstubs #{deploy_to}/shared/binstubs"