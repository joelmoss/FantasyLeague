class ConversationsMailer < ActionMailer::Base
  default from: "Fantasy League <joel@developwithstyle.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.conversations_mailer.new_conversation.subject
  #
  def new_conversation(conversation)
    @conversation = conversation
    mail to: conversation.recipient, subject: "New message: #{conversation}"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.conversations_mailer.new_message.subject
  #
  def new_message(message, manager)
    @message, @manager = message, manager
    mail to: manager, subject: "New reply to #{message.conversation}"
  end
end
