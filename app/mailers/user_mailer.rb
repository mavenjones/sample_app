class UserMailer < ActionMailer::Base
  default :from => "mavenjones@gmail.com"
  
  def registration_confirmation(user)
    @user = user
    mail(:to => user.email, :subject => "Registration")
  end
  
  def follower_notification(user,follower)
    @user = user
    @follower = follower
    mail(:to => user.email, :subject => "You are being followed!")
  end
end
