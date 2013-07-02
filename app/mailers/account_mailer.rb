class AccountMailer < ActionMailer::Base
  default :from => "Wallsome Support <support@wallsome.com>"
  default_url_options[:host] = HOST
  
  def verification(user)
    @user = user
    mail(:to => user.email, :subject => "Account verification for Wallsome")
  end
end
