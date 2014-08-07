class PlayersGrid

  include Datagrid

  scope do
    Player.includes(:team_player, :team)
  end


  filter :full_name
  filter :position, :enum, select: -> { Player::POSITIONS.map {|k,v| ["#{v}s",k] } }
  filter :club, :enum, select: -> { Player::CLUBS.map {|k,v| [v,k] } }
  filter :is_new, :boolean
  # filter(:free_agents, :boolean) do |val, scope|
  #   if val
  #     scope.joins(['LEFT OUTER JOIN `team_players` ON `team_players`.`player_id` = `players`.`id`',
  #                  'LEFT OUTER JOIN `teams` ON `teams`.`id` = `team_players`.`team_id` WHERE',
  #                  '`team_players`.`id` IS NULL'].join(' '))
  #   else
  #     scope
  #   end
  # end


  column :position, header: 'Pos' do |asset|
    format(asset.position) do |value|
      content_tag :div, value, class: "label label-#{position_colour(value)}",
                               title: asset.full_position,
                               data: { toggle: 'tooltip', placement: 'right' }
    end
  end

  column :short_name, header: 'Name' do |asset|
    format(asset.short_name) do |value|
      link_to(value, asset) + ' ' + (content_tag(:span, 'new', class: 'label label-warning') if asset.is_new?)
    end
  end

  column :club

  column :team do |asset|
    format(asset.team) do |value|
      link_to_unless asset.free_agent?, value, value do
        '-'
      end
    end
  end

end
