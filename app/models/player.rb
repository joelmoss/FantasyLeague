class Player < ActiveRecord::Base

  has_many :seasons, class_name: 'PlayerSeason'

end
