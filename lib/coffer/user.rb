module Coffer
  class User
    attr_reader :token, :key

    def initialize(token, key)
      @token, @key = token, key
      @me = Coffer.tokens.get(token) if token
    rescue Riak::FailedRequest
      @me = nil
    end

    def valid?
      @me && valid_key == provided_key
    end

    def owns_bucket?(bucket)
      bucket = bucket.kind_of?(String) ? Coffer.buckets.get(bucket) : bucket
      bucket.data['authorized_tokens'] && bucket.data['authorized_tokens'].include?(token)
    end


    def valid_key
      JSON.parse(@me.data)['key']
    end
    
    def provided_key
      @key
    end
  end
end
