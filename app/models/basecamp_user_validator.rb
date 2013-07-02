class BasecampUserValidator < ActiveModel::Validator
  def validate(basecamp_user)
    old_site = Person.site
    old_user = Person.user
    begin
      Person.site = basecamp_user.basecamp_account.url
      Person.user = basecamp_user.api_token
      Person.find(:one, :from => "/me")
    rescue ActiveResource::ResourceNotFound, URI::InvalidURIError
      basecamp_user.errors.add(:account_name, "The Basecamp account was not found")
    rescue ActiveResource::UnauthorizedAccess
      basecamp_user.errors.add(:api_token, "Please enter a valid api token (see 'My info' in Basecamp)")
    rescue ActiveResource::ForbiddenAccess
      basecamp_user.errors.add(:api_token, "Please enable the Basecamp API for your account. See 'Account (Upgrade/Invoices)' in Basecamp.")
    ensure
      Person.site = old_site
      Person.user = old_user
    end
  end
end
