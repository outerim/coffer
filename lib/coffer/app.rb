module Coffer
  class App
    class NotAuthorized < StandardError; end
    class NotFound < StandardError; end

    def self.handler
      lambda { |env| self.new(env).call }
    end

    def initialize(env)
      @env = env
    end

    def call
      route_request
    rescue NotAuthorized
      not_authorized
    rescue NotFound
      not_found
    #rescue
      #internal_error
    end

    def route_request
      case [request.request_method.to_sym, request.path]
        when Case[:PUT, Object], Case[:POST, Object]
          create_object(*bucket_and_key_from_uri)
        when Case[:GET, Object]
          retrieve_object(*bucket_and_key_from_uri)
        when Case[:DELETE, Object]
          delete_object(*bucket_and_key_from_uri)
        else
          raise NotFound
      end
    end

    def create_object(bucket, key)
      raise NotAuthorized unless user.valid? && user.owns_bucket?(bucket)

      # TODO: stream files in? split biig files to multiple keys & link?
      obj = store.bucket(bucket).get_or_new(key)
      obj.content_type = request.content_type
      obj.raw_data = request.body.read

      obj.store(:returnbody => false) # We're not going to use the body, so don't read it back
      [200, {}, []]
    end

    def retrieve_object(bucket, key)
      obj = store.bucket(bucket).get(key)

      [200, headers_for_object(obj), [obj.raw_data]]
    rescue Riak::FailedRequest => fr
      handle_riak_error(fr)
    end

    def delete_object(bucket, key)
      raise NotAuthorized unless user.valid? && user.owns_bucket?(bucket)

      resp = store.bucket(bucket).delete(key)
      [resp[:code], {}, []]
    end

    def headers_for_object(obj)
      { "Content-type" => obj.content_type,
        "Etag" => obj.etag,
        "Last-modified" => obj.last_modified.to_s
      }
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def store
      Coffer.store
    end

    def user
      @user ||= User.new(request.env['API_TOKEN'], request.env['API_KEY'])
    end

    def not_found
      [404, { "Content-type" => "text/html" }, ["Not Found"]]
    end

    def not_authorized
      [403, { "Content-type" => "text/html" }, ["Not Authorized"]]
    end

    def bucket_and_key_from_uri
      # TODO: Should we allow / in a bucket name? I think so, in which case this is a broken approach
      request.path[1..-1].split('/')
    end

    def handle_riak_error(fr)
      if fr.code.to_i == 404
        [404, {}, []]
      else
        raise
      end
    end
  end
end
