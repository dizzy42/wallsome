require 'digest/md5'

module ActiveResource
  module Caching
    extend ActiveSupport::Concern

    included do
      cattr_accessor :use_cache
      cattr_accessor :cache

      alias_method_chain :get, :cache
      alias_method_chain :head, :cache
    end

    module ClassMethods

      def clear_cache
        self.cache = {}
      end

    end

    module InstanceMethods

      def get_with_cache(path, headers = {})
        return get_without_cache(path, headers) unless use_cache
        cached_request(:get, path, header = {})
      end

      def head_with_cache(path, headers = {})
        return head_without_cache(path, headers) unless use_cache
        cached_request(:head, path, header = {})
      end
      
      protected
      
        def cached_request(method, path, headers = {})
          key = cache_key(method, path, headers)
          self.cache ||= {}
          ActiveResource::Base.logger.info("Cache: #{method.to_s.upcase} #{path}") if cache[key]
          (self.cache[key] ||= send("#{method}_without_cache", path, headers)).clone
        end
        
        def cache_key(method, path, headers)
          Digest::MD5.hexdigest("#{method}:#{path}:#{headers.to_s}")
        end
    end
  end
end

ActiveResource::Connection.send(:include, ActiveResource::Caching)
