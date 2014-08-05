class PlayersGrid

  include Datagrid

  scope do
    Player
  end

  filter :full_name
  filter :position, :enum, select: -> { Player::POSITIONS.map {|k,v| ["#{v}s",k] } }
  filter :club, :enum, select: -> { Player::CLUBS.map {|k,v| [v,k] } }

  column :position, header: 'Pos' do |asset|
    format(asset.position) do |value|
      content_tag :div, value, class: "label label-info"
    end
  end
  column :short_name, header: 'Name' do |asset|
    format(asset.short_name) do |value|
      link_to value, asset
    end
  end
  column :club

end
