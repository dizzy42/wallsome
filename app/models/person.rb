class Person < BasecampResource
  def self.me
    find(:one, :from => "/me")
  end
  
  def name_for_display(abbreviated=true)
    return first_name if last_name.nil?
    if abbreviated
      "#{first_name} #{last_name.mb_chars[0]}."
    else
      "#{first_name} #{last_name}"
    end
  end
  
  def responsible_party_id
    id
  end
  
  def <=>(other)
    self.name_for_display <=> other.name_for_display
  end
end
