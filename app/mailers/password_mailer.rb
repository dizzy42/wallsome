class PasswordMailer < ActionMailer::Base
  default :from => "Wallsome Support <support@wallsome.com>"
  default_url_options[:host] = HOST
  
  def forgot(user)
    @user = user
    mail(:to => user.email, :subject => "Forgot password for Wallsome")
  end
  
end
