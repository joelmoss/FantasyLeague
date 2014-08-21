class Manager < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include PublicActivity::Model
  tracked only: [ :create ]

  has_one :team
  has_many :watches
  has_many :watchings, through: :watches, source: :player
  has_many :sealed_bids

  default_scope { order :name }
  scope :approved, -> { where approved: true }
  scope :unapproved, -> { where approved: false }

  before_create :make_first_approved
  after_create :send_admin_mail

  validates :mobile_number, presence: true
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

  def has_bid?(player=nil)
    player ? sealed_bids.exists?(player: player) : sealed_bids.exists?
  end


  private

    def make_first_approved
      if Manager.count < 1
        self.admin = true
        self.approved = true
      end
    end

    def send_admin_mail
      AdminMailer.new_user_waiting_for_approval(self).deliver
    end

end
