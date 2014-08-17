desc 'Process team sheets'
task process: :environment do

  # Take all players who are not subs, and apply them as starting for their team.
  Team.all.each do |team|
    team.players.starting_lineup.update_all starting: true
    team.players.substitutes.update_all starting: false

    # Create the team sheets
    team.players.starting_lineup.each do |rec|
      team.team_sheets.create player: rec.player, date: Date.yesterday
    end

    team.players.starting_lineup.each do |rec|
      team.team_sheets.create player: rec.player, date: Date.today
    end
  end

end
