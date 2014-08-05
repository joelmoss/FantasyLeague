class TeamPlayersGrid

  include Datagrid

  scope do
    TeamPlayer.order(:substitute)
  end

  column :substitute, header: '-', order: false do |asset|
    format(asset.substitute) do |value|
      content_tag :span, class: 'fa-stack' do
        if value
          concat icon(:square, '', class: 'fa-stack-2x')
          concat icon(:user, '', class: 'fa-stack-1x fa-inverse', title: 'Substitute', data: { toggle: 'tooltip', placement: 'right' })
        else
          concat icon(:square, '', class: 'fa-stack-2x highlight')
          concat icon(:user, '', class: 'fa-stack-1x fa-inverse highlight', title: 'Starting 11', data: { toggle: 'tooltip', placement: 'right' })
        end
      end
    end
  end

  column :position, header: 'Pos', order: proc { |scope| scope.joins(:player).order("players.position") } do |asset|
    format(asset.player.position) do |value|
      content_tag :div, value, class: "label label-#{position_colour(value)}", title: asset.player.full_position, data: { toggle: 'tooltip', placement: 'right' }
    end
  end

  column :short_name, header: 'Name', order: proc { |scope| scope.joins(:player).order("players.short_name") } do |asset|
    format(asset.player.short_name) do |value|
      link_to value, team_player_path(asset.team, asset)
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
