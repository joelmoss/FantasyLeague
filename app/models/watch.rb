class Watch < ActiveRecord::Base

  belongs_to :player
  belongs_to :manager

end
