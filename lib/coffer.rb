require 'case'
require 'revactor'
require 'riak/client'

module Coffer
  DefaultStoreOptions = { :host => 'localhost', :port => 8091 }

  def self.store
    setup_store unless @store
    @store
  end

  def self.setup_store(options={})
    @store ||= Riak::Client.new(DefaultStoreOptions.merge(options))
  end

  def self.tokens
    store.bucket('coffer_tokens')
  end
end

require 'coffer/app'
require 'coffer/user'
require 'coffer/riak_monkeypatch'
