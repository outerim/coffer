require 'rspec'
require 'rack/test'
require 'cucumber'

require 'coffer'

require File.join(File.dirname(__FILE__), 'fixture_helpers')
require File.join(File.dirname(__FILE__), 'api_helpers')
require File.join(File.dirname(__FILE__), 'data_store_helpers')

module MyWorld
  include Rack::Test::Methods
  include DataStore::RealRiak
  include FixtureHelpers
  include ApiHelpers

  def app
    Coffer::App.handler
  end
end

World(MyWorld)
