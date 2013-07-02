module BasecampResourceIdentityMap
  # An eager-loading, caching access to Basecamp resources.
  # 
  # Should be used instead of individual BasecampResource.find calls 
  # to reduce the number of Basecamp API calls.
  # 
  # For a definition of the pattern see
  # http://martinfowler.com/eaaCatalog/identityMap.html
  class Base
  
    class << self

      def find(id)
        @cache ||= find_all
        @cache.detect{|resource| resource.id == id.to_i }
      end
      
      def clear_all_caches
        subclasses.each do |subclass|
          subclass.clear_cache
        end
      end
    
      def clear_cache
        @cache = nil
      end
      
      protected
      
        def resource_class
          "#{self.to_s.demodulize}".constantize
        end
    
        def find_all
          resource_class.all
        end
        
      private
        
        def subclasses
          [
            BasecampResourceIdentityMap::Company,
            BasecampResourceIdentityMap::Person
          ]
        end
    end
  end
end
