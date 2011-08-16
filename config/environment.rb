# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.12' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/app/services/api )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"

  #config.gem 'formtastic', :version => '0.9.10' has a bug, now in vendor/plugins
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  config.gem 'rake', :version => '0.8.7'
  config.gem 'delayed_job', :version => '2.0.3'
  config.gem 'searchlogic', :version => '2.4.27'
  config.gem 'rest-client', :version => '1.5.1', :lib => 'rest_client'
  config.gem 'fortify', :source => 'http://gemcutter.org'
  config.gem 'mongrel'
  config.gem 'thebeanmachine-actionwebservice', :lib => 'actionwebservice', :version => '2.3.2', :source => "http://intern.thebeanmachine.nl/rubygems"
  #config.gem 'cancan', :version => '1.1.1' master HEAD is now in vendor/plugins, missing feature in last version
  config.gem 'devise', :version => '1.0.6'
  config.gem 'formtastic', :lib => 'formtastic', :version => '1.1.0'
  config.gem 'less', :version => '1.2.21'
  config.gem 'will_paginate'
  config.gem 'builder'
  config.gem 'i18n', "~> 0.4.0"
  config.gem 'nokogiri', :version => '1.4.4'
  config.gem 'mysql'
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of definitions for finding time zone names.
  config.time_zone = 'Amsterdam'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  config.i18n.default_locale = :nl
  
  
end
