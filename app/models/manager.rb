class Manager < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :team
  has_many :watches
  has_many :watchings, through: :watches, source: :player

  scope :approved, -> { where approved: true }
  scope :unapproved, -> { where approved: false }

  after_create :send_admin_mail

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }


  def to_s
    name || email
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end


  private

    def send_admin_mail
      AdminMailer.new_user_waiting_for_approval(self).deliver
    end

end
