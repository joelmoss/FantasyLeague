namespace :scrape do

  positions = %w( g f c m s )
  metrics = {
    pld: 'played',
    gls: 'goals',
    ass: 'assists',
    cs: 'clean sheets',
    ga: 'goals against',
    tot: 'total'
  }

  club_alt_names = {
    'Arsenal' => 'ars',
    'Aston Villa' => 'av',
    'Burnley' => 'bur',
    'Chelsea' => 'che',
    'Crystal Palace' => 'cp',
    'Everton' => 'eve',
    'Hull' => 'hul',
    'Leicester' => 'lei',
    'Liverpool' => 'liv',
    'Man City' => 'mc',
    'Man Utd' => 'mu',
    'Newcastle' => 'new',
    'QPR' => 'qpr',
    'Southampton' => 'sot',
    'Stoke' => 'sto',
    'Sunderland' => 'sun',
    'Swansea' => 'swa',
    'Tottenham' => 'tot',
    'West Brom' => 'wba',
    'West Ham' => 'wh'
  }

  desc 'Scrape fixture and result data from FantasyLeague.com'
  task fixtures: :environment do

    puts "\n Beginning a new fixture scrape...\n\n"

    datetime = ''
    next_up = true

    agent = Mechanize.new
    page = agent.get('http://www.fantasyleague.com/Pro/Stats/ResultsAndFixtures.aspx')
    page.search('#matches > table tr').each do |row|
      if row[:id] && row[:id].start_with?('day_')
        time, date = row.search('th > div')
        datetime = DateTime.parse "#{time.content} #{date.content}"

        # Skip this fixture if it is not taking place today
        next unless next_up = Date.yesterday == datetime.to_date
      elsif row[:class] && row[:class].include?('top')
        next unless next_up

        home_club = Club.find_by(short_name: club_alt_names[row.search('td:nth-child(2) h2').first.content])
        away_club = Club.find_by(short_name: club_alt_names[row.search('td:nth-child(4) h2').first.content])

        match = row.search('td:nth-child(3) a').first
        score = match.content

        # Ignore if fixture already exists
        if Fixture.exists?(home_club_id: home_club.id, away_club_id: away_club.id, date: datetime.to_date)
          next
        else
          puts " >>>> #{datetime.to_s(:short)}    #{home_club} #{score} #{away_club}"

          fixture = Fixture.create do |f|
            f.home_club = home_club
            f.away_club = away_club
            f.home_score = score.split(':').first
            f.away_score = score.split(':').last
            f.date = datetime
            f.time = datetime
          end
        end

        sleep 1

        agent.transact do
          match = agent.click match

          puts " ---> Scraping home team players..."

          match.search('.results-home tbody tr').each do |player|
            name = player.search('td:nth-child(2) a').first.content

            unless db_player = Player.unscoped.find_by(short_name: name)
              puts "      ERROR: Failed to find player '#{name}'. Creating..."

              db_player = Player.create do |r|
                position = player.css('td:nth-child(1) div').first[:class].split
                position.delete('pos')
                r.position = (@position = position.first.last.to_i) == 6 ? @position-2 : @position-1
                r.short_name = name
                r.full_name = name
                r.image = ''
                r.club = home_club
              end
            end

            if fixture.players.exists? db_player
              fp = fixture.fixture_players.find_by(player_id: db_player.id)
            else
              fp = fixture.fixture_players.build
              fp.player = db_player
            end
            fp.pld = player.search('td:nth-child(4)').first.content
            fp.gls = player.search('td:nth-child(5)').first.content
            fp.ass = player.search('td:nth-child(6)').first.content
            fp.cs = player.search('td:nth-child(7)').first.content
            fp.ga = player.search('td:nth-child(8)').first.content
            fp.tot = player.search('td:nth-child(9)').first.content
            fp.red_card = !player.search('td:nth-child(2) div.redcard').empty?
            fp.yellow_card = !player.search('td:nth-child(2) div.yellowcard').empty?
            fp.full_game = !player.search('td:nth-child(3) div.playedfull').empty?
            fp.subbed_off = !player.search('td:nth-child(3) div.cameoff').empty?
            fp.subbed_on = !player.search('td:nth-child(3) div.cameon').empty?
            fp.save!
          end

          puts " ---> Scraping away team players..."

          match.search('.results-away tbody tr').each do |player|
            name = player.search('td:nth-child(2) a').first.content

            unless db_player = Player.unscoped.find_by(short_name: name)
              puts "      ERROR: Failed to find player '#{name}'. Creating..."

              db_player = Player.create do |r|
                position = player.css('td:nth-child(1) div').first[:class].split
                position.delete('pos')
                r.position = (@position = position.first.last.to_i) == 6 ? @position-2 : @position-1
                r.short_name = name
                r.full_name = name
                r.image = ''
                r.club = away_club
              end
            end

            if fixture.players.exists? db_player
              fp = fixture.fixture_players.find_by(player_id: db_player.id)
            else
              fp = fixture.fixture_players.build
              fp.player = db_player
            end
            fp.pld = player.search('td:nth-child(4)').first.content
            fp.gls = player.search('td:nth-child(5)').first.content
            fp.ass = player.search('td:nth-child(6)').first.content
            fp.cs = player.search('td:nth-child(7)').first.content
            fp.ga = player.search('td:nth-child(8)').first.content
            fp.tot = player.search('td:nth-child(9)').first.content
            fp.red_card = !player.search('td:nth-child(2) div.redcard').empty?
            fp.yellow_card = !player.search('td:nth-child(2) div.yellowcard').empty?
            fp.full_game = !player.search('td:nth-child(3) div.playedfull').empty?
            fp.subbed_off = !player.search('td:nth-child(3) div.cameoff').empty?
            fp.subbed_on = !player.search('td:nth-child(3) div.cameon').empty?
            fp.save!
          end
        end

        puts " ---> Adding today's fixtures to team's points..."

        # Update team season points
        year = Date.today.month <= 6 ? Date.today.year - 1 : Date.today.year
        Team.all.each do |team|
          unless (points = fixture.points_for_team(team)).empty?
            # collect all points for FixtureTeam
            ft = fixture.fixture_teams.create team: team
            ft.update points

            current = team.seasons.current
            FixturePlayer::METRICS.keys.map do |m|
              next if m === :pld
              points[m] = (current.try(m) || 0) + (points[m] || 0)
            end

            points.delete(:pld)
            puts "      #{team.to_s.ljust(25)}#{points}"
            team.seasons.find_or_initialize_by(season: year).update(points)
          end
        end

        puts ""

      end
    end

    puts "\n Completed fixture scrape!\n\n"
  end
end