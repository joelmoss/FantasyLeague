class Message < ActiveRecord::Base

  belongs_to :conversation, inverse_of: :messages
  belongs_to :manager

  validates :conversation, presence: true
  validates :body, presence: true
  after_create :notify_participants


  private

    def notify_participants
      if conversation.messages.count > 1
        conversation.participants.each do |manager|
          ConversationsMailer.new_message(self, manager).deliver unless manager == self.manager
        end
      end
    end

end
