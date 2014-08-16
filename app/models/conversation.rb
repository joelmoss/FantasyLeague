class Conversation < ActiveRecord::Base

  has_many :messages, validate: true, inverse_of: :conversation, dependent: :destroy
  belongs_to :creator, class_name: 'Manager'
  belongs_to :recipient, class_name: 'Manager'

  accepts_nested_attributes_for :messages
  acts_as_paranoid
  default_scope { order created_at: :desc }
  validates :subject, presence: true
  validates :recipient, presence: true

  def to_s
    subject
  end

end
