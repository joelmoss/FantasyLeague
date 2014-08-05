class Team < ActiveRecord::Base

  belongs_to :manager

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }


  def to_s
    name
  end

end
