module PlayersHelper

  POSITION_COLOURS = {
    g: 'primary',
    f: 'success',
    c: 'info',
    m: 'warning',
    s: 'danger'
  }

  def position_colour(pos)
    POSITION_COLOURS[pos.downcase.to_sym]
  end

end
