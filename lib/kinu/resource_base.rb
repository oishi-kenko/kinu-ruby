require 'kinu/geometry'
require 'kinu/http_client'

module Kinu
  class ResourceBase
    attr_reader :name, :id

    def initialize(name, id, options = {})
      @name, @id, @options = name, id, options
    end

    def uri(options)
      timestamp      = options.delete(:timestamp)
      format         = (options.delete(:format) || :jpg)
      geometry       = Geometry.new(options)
      build_uri(geometry, format, timestamp)
    end

    def path(options)
      format         = (options.delete(:format) || :jpg)
      geometry       = Geometry.new(options)
      build_path(geometry, format)
    end

    private

    def build_path(geometry, format)
      "/images/#{@name}/#{geometry}/#{@id}.#{format}"
    end

    def build_uri(geometry, format, timestamp)
      uri = base_uri.dup
      if @options[:ssl]
        uri.scheme = 'https'
      end

      uri.path  = build_path(geometry, format)

      if !timestamp.nil? && timestamp.respond_to?(:to_i)
        uri.query = "#{timestamp.to_i}"
      elsif !timestamp.nil?
        uri.query = timestamp.to_s
      end

      uri
    end

    def base_uri
      Kinu.base_uri
    end
  end
end
