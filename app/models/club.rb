class Club < ActiveRecord::Base

  has_many :players


  def to_s
    name
  end

  def short_name
    read_attribute(:short_name).upcase
  end

end
