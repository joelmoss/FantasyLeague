desc 'Process team sheets'
task process: :environment do

  # Take all players who are not subs, and apply them as starting for their team.
  Team.all.each do |team|
    team.players.starting_lineup.update_all starting: true
    team.players.substitutes.update_all starting: false
  end

  # Loop through all starting team players and fetch points

end
