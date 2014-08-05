class AdminMailer < ActionMailer::Base

  default from: "from@example.com"


  def new_user_waiting_for_approval(manager)
    @manager = manager
    admins = Manager.where(admin: true).pluck(:email)
    mail to: admins, subject: 'New Manager needs Approval'
  end

end
