# Parent class for Basecamp API resources
# http://developer.37signals.com/basecamp/
class BasecampResource < ActiveResource::Base
  
  XML_REQUEST_HEADERS = { 
    "Accept" => "application/xml", 
    "Content-Type" => "application/xml" 
  }
  
  class << self
    # Sets the site URI for all our Basecamp resource requests.
    # 
    # Must be used instead of site= to avoid "Missing site URI" when 
    # config.cache_classes = true (in production).
    def site_for_all_subclasses=(site)
      subclasses.each do |subclass|
        subclass.site = site
      end
    end
    
    # Sets the user for all our Basecamp resource requests.
    # 
    # Must be used instead of user= to avoid "Authorization Required" when 
    # config.cache_classes = true (in production).
    def user_for_all_subclasses=(user)
      subclasses.each do |subclass|
        subclass.user = user
      end
    end
    
    private
    
      def subclasses
        [
          Company,
          Milestone,
          Person,
          Project,
          TodoItem,
          TodoList,
          Comment
        ]
      end
      
  end
end
