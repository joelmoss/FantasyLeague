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

  desc 'Scrape player data from FantasyLeague.com'
  task players: :environment do
    testing = ENV['TEST']
    records_updated = []
    new_players = []
    changed_club = []
    agent = Mechanize.new

    puts "\nBeginning a new players scrape...\n\n"

    page = if testing
      agent.get('http://localhost:3000/scrapetest/playerlist.html')
    else
      agent.get('http://www.fantasyleague.com/Pro/Stats/playerlist.aspx?dpt=0')
    end

    page.search('#playerlist > .player-list-table > tbody > tr').each do |player|

      position = player.css('td:nth-child(1) div').first[:class].split
      position.delete('pos')
      @position = (@position = position.first.last.to_i) == 6 ? @position-2 : @position-1

      @is_new = !player.css('td:nth-child(2) span.new').empty?

      player_link = player.css('td:nth-child(2) a').first
      @short_name = player_link.content

      status = player.css('td:nth-child(3) > .playerstatus')
      if status.empty?
        @status, @status_notes = nil
      else
        status = status.first
        classes = status[:class].split
        if classes.include? 'injured'
          @status = 'injured'
          @status_notes = status['title'].strip
        elsif classes.include? 'doubtful'
          @status = 'doubtful'
          @status_notes = status['title'].strip
        elsif classes.include? 'suspended'
          @status = 'suspended'
          @status_notes = status['title'].strip
        elsif classes.include? 'latefitnesstest'
          @status = 'latefitnesstest'
          @status_notes = status['title'].strip
        else
          @status, @status_notes = nil
        end
      end

      @club = Club.find_by(short_name: player.css('td:nth-child(5) a').first.content.strip.downcase)

      sleep 1

      begin
        agent.transact do
          player_page = if testing
            agent.get('http://localhost:3000/scrapetest/player.html')
          else
            agent.click player_link
          end

          content = player_page.search('.content')
          @full_name = content.search('> h1').first.content

          content = content.search('> #playerProfile')
          @image = content.search('> img.profile-image').first[:src]

          # Home/away form
          # form = {
          #   home: metrics,
          #   away: metrics
          # }
          # home, away = content.search('#premierLeagueForm tbody tr')
          # null, form[:home][:pld], form[:home][:gls], form[:home][:ass], form[:home][:cs], form[:home][:ga] = home.search('td').map do |i|
          #   i.content.to_i
          # end
          # null, form[:away][:pld], form[:away][:gls], form[:away][:ass], form[:away][:cs], form[:away][:ga] = away.search('td').map do |i|
          #   i.content.to_i
          # end

          # Fixtures & Results
          # player_page.search('#All > table tbody tr').each do |row|
          #   fixture = {}
          #   cells = row.search('td')

          #   fixture[:datetime] = "#{cells[0].content} #{cells[1].content} BST".to_datetime

          #   opponent, location = cells[3].content.split('(')
          #   fixture[:opponent] = opponent.strip
          #   fixture[:location] = location.strip.sub(')', '')
          # end

          # Create the player
          record = Player.find_or_initialize_by(full_name: @full_name)
          record.club = @club
          record.short_name = @short_name
          record.image = @image
          record.position = @position
          record.is_new = @is_new
          record.status = @status
          record.status_notes = @status_notes
          club_id_changed = false

          # Is the player new?
          if record.new_record?
            # TODO: send notification of new player
            puts " + [#{Player::POSITIONS[@position][:abbr]}] #{@short_name.ljust(20)} (#{@club.short_name})"
            record.save
            new_players << record
          else
            if record.changed?
              puts " ± [#{Player::POSITIONS[@position][:abbr]}] #{@short_name.ljust(20)} (#{@club.short_name})"
              puts "   #{record.changes}"
              puts "   Plays for #{record.team} (#{record.team.manager})" if record.team

              club_id_changed = record.club_id_changed? ? record.club_id_change : false
              puts "   FAILED to save!" unless record.save
            end
          end

          changed_club << { player: record, club_change: club_id_changed } if club_id_changed
          records_updated << record.id


          # Premier League Form
          current_season = Date.today.year
          points = metrics
          cells = content.search('#premierLeagueForm tfoot tr:first-child td')
          null, points[:pld], points[:gls], points[:ass], points[:cs], points[:ga], points[:tot] = cells.map do |i|
            i.content.to_i
          end
          if record.seasons.exists?(season: current_season)
            season = record.seasons.where(season: current_season).first
            season.update_attributes points
          else
            record.seasons.create({ season: current_season }.merge(points))
          end


          # Previous seasons
          seasons_page = if testing
            agent.get 'http://localhost:3000/scrapetest/player-prev.html'
          else
            agent.get player_page.uri.to_s + '?groupid=5'
          end

          seasons_page.search('#PreviousSeasons > table tbody tr').each do |row|
            cells = row.search('td')
            if !record.seasons.exists?(season: cells[0].content.to_i)
              record.seasons.create season: cells[0].content.to_i,
                                    pld: cells[1].content.to_i,
                                    gls: cells[2].content.to_i,
                                    ass: cells[3].content.to_i,
                                    cs: cells[4].content.to_i,
                                    ga: cells[5].content.to_i,
                                    tot: cells[6].content.to_i
            end
          end
        end
      # rescue => e
      #   $stderr.puts "#{e.class}: #{e.message}"
      end

      exit if testing
    end

    # Find and destroy any removed players.
    removed_players = []
    (Player.all.pluck(:id) - records_updated).each do |id|
      player = Player.find(id)
      removed_players << player
      puts " - [#{player.position}] #{player.short_name.ljust(20)} (#{player.club.short_name})"
      puts "   Played for #{player.team} (#{player.team.manager})" if player.team
      player.destroy
    end

    # Send email to managers about new and removed players
    if !new_players.empty? || !removed_players.empty? || !changed_club.empty?
      Manager.all.each do |manager|
        PlayersMailer.new_players(manager, new_players, removed_players, changed_club).deliver
      end
    end

    puts "\nCompleted!\n"

  end

end