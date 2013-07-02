class User < ActiveRecord::Base
  has_many :basecamp_users, :dependent => :destroy
  has_many :basecamp_accounts, :through => :basecamp_users

  attr_accessor :password, :password_confirmation

  validates_presence_of     :email
  validates_uniqueness_of   :email, :case_sensitive => false
  validates_format_of       :email, :with => %r{.+@.+\..+}

  validates_presence_of     :password, :unless => :password_optional?
  validates_confirmation_of :password, :unless => :password_optional?


  before_create :generate_remember_token

  before_save :initialize_salt,
              :encrypt_password,
              :initialize_verification_token


  def self.authenticate(email, password)
    return nil unless user = find_by_email(email)
    return user if user.authenticated?(password)
  end

  def authenticated?(password)
    encrypted_password == encrypt(password)
  end

  def reset_remember_token!
    generate_remember_token
    save(:validate => false)
  end

  def api_token_for(basecamp_account)
    basecamp_users.where(:basecamp_account_id => basecamp_account.id).first.api_token
  end

  def forgot_password!
    generate_verification_token
    save(:validate => false)
  end

  def update_password(new_password, new_password_confirmation)
    self.password              = new_password
    self.password_confirmation = new_password_confirmation
    if valid?
      self.verification_token = nil
    end
    save
  end

  def confirm_email!
    self.verified           = true
    self.verification_token = nil
    save(:validate => false)
  end

  private

    def password_optional?
      encrypted_password.present? && password.blank?
    end

    def initialize_salt
      if new_record?
        self.salt = generate_hash("--#{Time.now.utc}--#{password}--#{rand}--")
      end
    end

    def encrypt_password
      return if password.blank?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      generate_hash("--#{salt}--#{string}--")
    end

    def generate_hash(string)
      Digest::SHA1.hexdigest(string)
    end

    def generate_remember_token
      self.remember_token = encrypt("--#{Time.now.utc}--#{encrypted_password}--#{id}--#{rand}--")
    end

    def generate_verification_token
      self.verification_token = encrypt("--#{Time.now.utc}--#{password}--")
    end

    def initialize_verification_token
      generate_verification_token if new_record?
    end
end
