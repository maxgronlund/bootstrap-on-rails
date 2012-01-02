require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'remarkable/active_record'

  # Add this to load Capybara integration:
  require 'capybara/rspec'
  require 'capybara/rails'
  Capybara.javascript_driver = :akephalos
  Akephalos::RemoteClient.manager

  require 'database_cleaner'
end

Spork.each_run do
  # This code will be run each time you run your specs.
  
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # required to make akephalos work with spork
    Thread.current['DRb'] = { 'server' => DRb::DRbServer.new }
  end
end

# Quick'n'dirty hack to make transactional fixtures work with Capybara et.al.
ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  def current_connection_id
    # Thread.current.object_id
    Thread.main.object_id
  end
end
