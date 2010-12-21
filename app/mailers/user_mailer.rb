class UserMailer < ActionMailer::Base
  default :from => "mavenjones@gmail.com"
  
  def recovery(options)

    @key = options[:key]
    @domain = options[:domain]
    mail(:to => options[:email], :subject => "Account Recovery from Sample App")
  end
  
  def registration_confirmation(options)
    @name = options[:name]
    @username = options[:username]
    @key = options[:key]
    @domain = options[:domain]
    mail(:to => options[:email], :subject => "Account Verification from Sample App")
  end
  
  def follower_notification(user,follower)
    @user = user
    @follower = follower
    mail(:to => user.email, :subject => "You are being followed!")
  end
end
