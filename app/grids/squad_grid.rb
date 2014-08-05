class SquadGrid

  include Datagrid

  scope do
    Squad
  end

  column :position, header: 'Pos', order: proc { |scope| scope.joins(:player).order("players.position") } do |asset|
    format(asset.player.position) do |value|
      content_tag :div, value, class: "label label-info"
    end
  end
  column :short_name, header: 'Name', order: proc { |scope| scope.joins(:player).order("players.short_name") } do |asset|
    format(asset.player.short_name) do |value|
      link_to value, asset.player
    end
  end
  column :club, order: proc { |scope| scope.joins(:player).order("players.club") } do
    self.player.club
  end
  column :purchase_price do |asset|
    format(asset.purchase_price) do |value|
      "&pound;#{value}m"
    end
  end

end
