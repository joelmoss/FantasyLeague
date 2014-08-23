desc 'Process team sheets'
task process: :environment do

  # Take all players who are not subs, and apply them as starting for their team.
  Team.all.each do |team|
    team.players.starting_lineup.update_all starting: true
    team.players.substitutes.update_all starting: false

    # Create the team sheets
    team.players.starting_lineup.each do |rec|
      team.team_sheets.create player: rec.player, date: Date.today
    end
  end

end

namespace :calculate do
  task week: :environment do
    if Date.today.wday == 1

      year = Date.today.month <= 6 ? Date.today.year - 1 : Date.today.year
      week_beginning = Date.today.last_week.beginning_of_week
      week_end = week_beginning.end_of_week
      week_number = TeamWeek.where(season: year).group_by(&:week).count + 1

      puts "\n     Week #{week_number} (#{week_beginning} - #{week_end})\n\n"

      Fixture.where(date: week_beginning..week_beginning.end_of_week).each do |fixture|
        puts " --> #{fixture}"
        Team.all.each do |team|
          points = fixture.points_for_team(team)
          puts "     #{team} #{points}"

          query = {season: year, week: week_number, week_beginning: week_beginning, team: team}
          week = TeamWeek.find_or_initialize_by(query)
          week.gls = (week.gls || 0) + points[:gls]
          week.ass = (week.ass || 0) + points[:ass]
          week.cs = (week.cs || 0) + points[:cs]
          week.ga = (week.ga || 0) + points[:ga]
          week.tot = (week.tot || 0) + points[:tot]
          week.save
        end
      end

      puts "\n     Awarding prize money...\n\n"
      TeamWeek.last_week.order(tot: :desc).limit(3).each_with_index do |team,i|
        puts "     #{team.tot.to_s.rjust(3)} - #{team.team}"
        team.team.award_week_prize! i
      end
      puts "\n"

    end
  end

  task month: :environment do
    if Date.today.beginning_of_month == Date.today

      year = Date.today.month <= 6 ? Date.today.year - 1 : Date.today.year
      month_beginning = Date.today.last_month.beginning_of_month
      month_end = month_beginning.end_of_month
      month_number = TeamMonth.where(season: year).group_by(&:month).count + 1

      puts "\n     Month #{month_number} (#{month_beginning} - #{month_end})\n\n"

      Fixture.where(date: month_beginning..month_beginning.end_of_month).each do |fixture|
        puts " --> #{fixture}"
        Team.all.each do |team|
          points = fixture.points_for_team(team)
          puts "     #{team} #{points}"

          query = {season: year, month: month_number, month_beginning: month_beginning, team: team}
          month = TeamMonth.find_or_initialize_by(query)
          month.gls = (month.gls || 0) + points[:gls]
          month.ass = (month.ass || 0) + points[:ass]
          month.cs = (month.cs || 0) + points[:cs]
          month.ga = (month.ga || 0) + points[:ga]
          month.tot = (month.tot || 0) + points[:tot]
          month.save
        end
      end

      puts "\n     Awarding prize money...\n\n"
      TeamMonth.last_month.order(tot: :desc).limit(3).each_with_index do |team,i|
        puts "     #{team.tot.to_s.rjust(3)} - #{team.team}"
        team.team.award_month_prize! i
      end
      puts "\n"

    end
  end
end
