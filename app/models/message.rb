class Message < ActiveRecord::Base

  belongs_to :conversation, inverse_of: :messages
  belongs_to :manager

  validates :conversation, presence: true
  validates :body, presence: true
  after_create :notify_participants#, :increment_unread_messages


  private

    def notify_participants
      if conversation.messages.count > 1
        conversation.participants.each do |man|
          ConversationsMailer.new_message(self, man).deliver unless man == self.manager
        end
      else
        ConversationsMailer.new_conversation(conversation).deliver
      end
    end

    def increment_unread_messages
      conversation.participants.each do |man|
        man.increment! :unread_messages if man != self.manager
      end
    end

end
