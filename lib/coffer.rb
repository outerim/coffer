require 'case'
require 'revactor'
require 'riak/client'

module Coffer
  DefaultStoreOptions = { :host => 'localhost', :port => 8091 }

  def self.store
    Thread.current[:riak_client] ||= Riak::Client.new(riak_config)
  end

  def self.tokens
    store['__coffer_tokens']
  end

  def self.buckets
    store['__coffer_buckets']
  end

  def self.riak_config
    DefaultStoreOptions
  end
end

require 'coffer/app'
require 'coffer/user'
