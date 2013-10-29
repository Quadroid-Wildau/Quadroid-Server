source 'https://rubygems.org'

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

# rails, server
gem 'rails', '3.2.14'
gem 'thin'
gem 'mysql2'

# monitoring
gem 'newrelic_rpm'

# API / json / modeling
gem 'json'
gem 'therubyracer', '0.10.2', :require => 'v8'
gem 'active_model_serializers'
gem 'active_attr'

# API / auth
gem 'doorkeeper', '~> 0.7.0'
gem 'ruby-hmac'

# files / images
gem 'paperclip', '~> 3.5.1'
gem 'rmagick'
gem 'delayed_job_active_record'
gem 'delayed_paperclip'

# development
group :development, :test do
  # deployment
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'

  # errors & debugging
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_print'

  # logging
  gem 'quiet_assets'

  # testing
  gem 'rspec-rails'   # testing framework
  gem 'wirble'        #
  gem 'debugger'      # debugger
  gem 'simplecov', :require => false  # code coverage
  gem 'factory_girl_rails'
end

# assets
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
