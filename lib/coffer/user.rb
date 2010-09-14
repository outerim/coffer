module Coffer
  class User
    def initialize(token, key)
      @token, @key = token, key
      @me = Coffer.tokens.get(token) if token
    rescue Riak::FailedRequest
      @me = nil
    end

    def valid?
      @me && valid_key == provided_key
    end

    def valid_key
      JSON.parse(@me.data)['key']
    end
    
    def provided_key
      @key
    end
  end
end
