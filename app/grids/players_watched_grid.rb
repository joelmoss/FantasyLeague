class PlayersWatchedGrid < PlayersGrid

  column :remove, header: '' do |asset|
    format(asset.team) do |value|
      link_to icon(:eye, 'Stop Watching'), unwatch_player_path(asset), method: :delete, class: 'btn btn-success btn-xs pull-right'
    end
  end

end
