class Message < ActiveRecord::Base

  belongs_to :conversation, inverse_of: :messages

  validates :conversation, presence: true
  validates :body, presence: true

end
