require 'rspec'
require 'rack/test'
require 'cucumber'

require 'coffer'

require File.join(File.dirname(__FILE__), 'fixture_helpers')

module MyWorld
  include Rack::Test::Methods

  def app
    Coffer::App.handler
  end
end

module DataStore
  module RealRiak
    def wipe_data_store
      #NFI
    end
  end
end

World(MyWorld)
World(DataStore::RealRiak)
World(FixtureHelpers)
