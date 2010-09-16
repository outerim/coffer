require 'coffer'

require 'rack/test'

require File.join(File.dirname(__FILE__), 'support', 'fixture_helpers')
require File.join(File.dirname(__FILE__), 'support', 'api_helpers')
require File.join(File.dirname(__FILE__), 'support', 'data_store_helpers')
require File.join(File.dirname(__FILE__), 'support', 'rack_monkeypatch')

module RackApp
  def app
    Coffer::App.handler
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include DataStore::RealRiak
  config.include FixtureHelpers
  config.include ApiHelpers
  config.include RackApp

  config.before(:each) { wipe_data_store }
end
