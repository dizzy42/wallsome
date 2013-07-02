module MilestonesHelper
  
  def responsible_party_options(project)
    Rails.cache.fetch("#{current_user.id}_responsible_party_options_for_#{project.id}", :expires_in => 1.hour) do 
      parties = []
      parties << ResponsiblePartyOption.new("Anyone")
      me = Person.me
      parties << ResponsiblePartyOption.new("Me (#{me.name_for_display})", me.responsible_party_id)
      project.companies.each do |company|
        parties << ResponsiblePartyOption.new("--------")
        parties << ResponsiblePartyOption.new(company.name_for_display.mb_chars.upcase, company.responsible_party_id)
        parties += company.people & project.people - [me]
      end
      options_from_collection_for_select(parties, 'responsible_party_id', 'name_for_display')
    end
  end
  
  def responsible_party_id_to_display_name
    Rails.cache.fetch("responsible_party_map_for_#{current_account.id}", :expires_in => 1.hour) do 
      map = { "" => "" }
      Person.all.each do |person|
        map[person.responsible_party_id] = person.name_for_display
      end
      Company.all.each do |company|
        map[company.responsible_party_id] = company.name_for_display
      end
      map
    end
  end
  
  def milestones_options(project, current_milestone = nil)
    milestones_for_options = []
    milestones_for_options << MilestoneOption.new("None")
    milestones_for_options << MilestoneOption.new("--------", "abc123")
    project.not_completed_milestones.each do |milestone|
      milestones_for_options << MilestoneOption.new(milestone.title, milestone.id)
    end
    options_from_collection_for_select(milestones_for_options, 
                                      'milestone_id', 
                                      'title', 
                                      :selected => current_milestone.try(:id),
                                      :disabled => "abc123")
  end
  
  private
  
    class ResponsiblePartyOption
      attr_reader :responsible_party_id, :name_for_display
      
      def initialize(name_for_display, responsible_party_id = nil)
        @name_for_display = name_for_display
        @responsible_party_id = responsible_party_id
      end
    end
    
    class MilestoneOption
      attr_reader :milestone_id, :title
      
      def initialize(title, milestone_id = nil)
        @title = title
        @milestone_id = milestone_id
      end
    end
end
