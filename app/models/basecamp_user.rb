class BasecampUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :basecamp_account

  validates_presence_of :account_name, :message => "Please enter your Basecamp account name"
  validates_format_of   :account_name, :with => /^[a-z0-9-]+$/i, :message => "Please enter a valid Basecamp account name"
  validates_presence_of :api_token, :message => "Please enter your Basecamp api token"
  validates_associated  :basecamp_account
  validates_with BasecampUserValidator, :if => Proc.new { |bu| bu.basecamp_account.present? && bu.api_token.present? }

  after_create :set_basecamp_account_owner_id

  def api_token=(api_token)
    self.encrypted_api_token = api_token_encryptor.encrypt(api_token)
  end

  def api_token
    encrypted_api_token ? api_token_encryptor.decrypt(encrypted_api_token) : ''
  end

  def account_name=(account_name)
    self.basecamp_account = BasecampAccount.find_by_name(account_name)
    self.basecamp_account ||= BasecampAccount.new(:name => account_name)
  end

  def account_name
    basecamp_account.name
  end

  private

    def api_token_encryptor
      @@api_token_encryptor ||= ActiveSupport::MessageEncryptor.new(Wallsome::Application.config.api_token_encryption_secret)
    end

    def set_basecamp_account_owner_id
      if self.basecamp_account.basecamp_users.count == 1
        self.basecamp_account.update_attribute(:owner_id, user_id)
      end
    end

end
