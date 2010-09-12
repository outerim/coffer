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
        when Case[:put, Object], Case[:post, Object]
          create_object(*bucket_and_key_from_uri)
        when Case[:get, Object]
          retrieve_object(*bucket_and_key_from_uri)
        else
          render_404
      end
    end

    def create_object(bucket, key)
      # TODO: stream files in? split biig files to multiple keys & link?
      obj = store.bucket(bucket).get_or_new(key)
      obj.content_type = post_type
      obj.data = post_data

      obj.store(:returnbody => false) # We're not going to use the body, so don't read it back
      [200, {}, []]
    end

    def retrieve_object(bucket, key)
      obj = store.bucket(bucket).get(key)

      [200, headers_for_object(obj), [obj.data]]
    rescue Riak::FailedRequest => fr
      handle_exception(fr)
    end

    def render_404
      [404, { "Content-type" => "text/html" }, ["Not Found"]]
    end

    def headers_for_object(obj)
      { "Content-type" => obj.content_type,
        "Etag" => obj.etag,
        "Last-modified" => obj.last_modified.to_s
      }
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

    def bucket_and_key_from_uri
      # TODO: Should we allow / in a bucket name? I think so, in which case this is a broken approach
      request.path[1..-1].split('/')
    end

    def handle_exception(fr)
      if fr.code.to_i == 404
        [404, {}, []]
      else
        raise
      end
    end
  end
end
