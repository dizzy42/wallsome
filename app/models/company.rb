class Company < BasecampResource
  def name_for_display
    name
  end
  
  def responsible_party_id
    "c#{id}"
  end
  
  def <=>(other)
    self.name_for_display <=> other.name_for_display
  end

  def people
    Person.all(:from => "/companies/#{id}/people").sort
  end
end
