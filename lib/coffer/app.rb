module Coffer
  class App
    def self.handler
      lambda { |env| self.new(env).call }
    end

    def initialize(env)
      @env = env
    end

    def call
      case [request.method, request.path]
        when Case[:put, Object]
          create_object(*request.path[1..-1].split('/'))
        else
          [404, { "Content-type" => "text/html" }, ["Not Found"]]
      end
    end

    def create_object(bucket, key)
      obj = store.bucket(bucket).new(key)
      obj.content_type = post_type
      obj.data = post_data

      obj.store
      [200, {}, []]
    end

    def post_data
      @env['rack.input'].read
    end

    def post_type
      @env['Content-type']
    end

    def request
      @request ||= Request.new(@env)
    end

    def store
      Coffer.store
    end
  end
end
