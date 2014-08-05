class PlayerSeason < ActiveRecord::Base

  belongs_to :player


  def to_s
    season
  end

  def season
    from = read_attribute(:season)
    to = (from + 1).to_s[-2,2]
    "#{from}/#{to}"
  end

end
