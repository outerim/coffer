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
        when Case[:get, %r!^/test!]
          dummy2
        when Case[:get, Object]
          dummy
        else
          [404, { "Content-type" => "text/html" }, "Not Found"]
      end
    end

    def dummy2
      [200, { "Content-type" => "text/html" }, ["Hello Worldsss"]]
    end

    def dummy
      Actor.sleep(1)
      [200, { "Content-type" => "text/html" }, ["Hello World"]]
    end

    def request
      @request ||= Request.new(@env)
    end
  end
end
