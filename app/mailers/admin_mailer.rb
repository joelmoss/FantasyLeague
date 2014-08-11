class AdminMailer < ActionMailer::Base
  default from: "joel@developwithstyle.com"


  def new_user_waiting_for_approval(manager)
    @manager = manager
    admins = Manager.where(admin: true).pluck(:email)
    mail to: admins, subject: 'New Manager needs Approval'
  end

end
