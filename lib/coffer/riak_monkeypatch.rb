module Coffer
  module RObjectHacks
    # We don't want to serialize or deserialize anything. Just get/store it raw
    def deserialize(body)
      body
    end

    def serialize(payload)
      return payload if IO === payload
      payload.to_s
    end
  end
end

require 'riak/robject'
Riak::RObject.send(:include, Coffer::RObjectHacks)
