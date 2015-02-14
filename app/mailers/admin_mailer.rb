class AdminMailer < ActionMailer::Base
  default from: "Fantasy League <joel@developwithstyle.com>"


  def new_user_waiting_for_approval(manager)
    @manager = manager
    admins = Manager.where(admin: true).pluck(:email)
    mail to: admins, subject: 'New Manager needs Approval'
  end

  def scrape_error(type, message)
    @type, @message = type, message
    admins = Manager.where(admin: true).pluck(:email)
    mail to: admins, subject: "Scraping #{type} error"
  end

end
