class BasecampAccount < ActiveRecord::Base
  has_many :basecamp_users

  validates_presence_of   :name, :message => "Please enter your Basecamp account name"
  validates_format_of     :name, :with => /^[a-z0-9-]+$/i, :message => "Please enter a valid Basecamp account name"
  validates_uniqueness_of :name, :case_sensitive => false, :message => "The Basecamp account name is already taken"

  def url
    return nil unless name.present?
    "https://#{name}.basecamphq.com/"
  end

  def name=(name)
    write_attribute(:name, name.gsub("https://","").downcase)
  end
end
