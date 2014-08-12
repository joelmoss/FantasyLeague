class ManagerMailer < ActionMailer::Base
  default from: "joel@developwithstyle.com"


  def approved(manager)
    @manager = manager
    mail to: manager.email, subject: "You've been Approved for Fantasy League"
  end

end
