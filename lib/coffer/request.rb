module Coffer
  PATH_INFO      = 'PATH_INFO'.freeze
  REQUEST_METHOD = 'REQUEST_METHOD'.freeze

  class Request
    attr_reader :method, :path

    def initialize(env)
      @method = env[REQUEST_METHOD].downcase.to_sym
      @path   = env[PATH_INFO].downcase
    end
  end
end
