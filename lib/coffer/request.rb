module Coffer
  REQUEST_PATH   = 'REQUEST_PATH'.freeze
  REQUEST_METHOD = 'REQUEST_METHOD'.freeze

  class Request
    attr_reader :method, :path

    def initialize(env)
      @method = env[REQUEST_METHOD].downcase.to_sym
      @path   = env[REQUEST_PATH].downcase
    end
  end
end
