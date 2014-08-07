positions = {
  pos1: 'g',
  pos2: 'f',
  pos3: 'c',
  pos4: 'm',
  pos6: 's'
}

metrics = {
  pld: 'played',
  gls: 'goals',
  ass: 'assists',
  cs: 'clean sheets',
  ga: 'goals against'
}


task scrape: :environment do
  testing = ENV['TEST']

  agent = Mechanize.new

  page = if testing
    agent.get('http://localhost:3000/scrapetest/playerlist.html')
  else
    agent.get('http://www.fantasyleague.com/Pro/Stats/playerlist.aspx?dpt=0')
  end

  page.search('#playerlist > .player-list-table > tbody > tr').each do |player|

    position = player.css('td:nth-child(1) div').first[:class].split
    position.delete('pos')
    @position = positions[position.first.to_sym]

    @is_new = !player.css('td:nth-child(2) span.new').empty?

    player_link = player.css('td:nth-child(2) a').first
    @short_name = player_link.content
    @club = player.css('td:nth-child(5) a').first.content.strip

    puts "[#{@position.upcase}] #{@short_name}"

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

        # Premier League Form
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
        record.update_attributes short_name: @short_name,
                                 image: @image,
                                 club: @club,
                                 position: @position,
                                 is_new: @is_new

        # Previous seasons
        seasons_page = if testing
          agent.get 'http://localhost:3000/scrapetest/player-prev.html'
        else
          agent.get player_page.uri.to_s + '?groupid=5'
        end

        seasons_page.search('#PreviousSeasons > table tbody tr').each do |row|
          cells = row.search('td')
          begin
            record.seasons.create season: cells[0].content.to_i,
                                  pld: cells[1].content.to_i,
                                  gls: cells[2].content.to_i,
                                  ass: cells[3].content.to_i,
                                  cs: cells[4].content.to_i,
                                  ga: cells[5].content.to_i,
                                  tot: cells[6].content.to_i
          rescue; end
        end
      end
    # rescue => e
    #   $stderr.puts "#{e.class}: #{e.message}"
    end

    exit if testing
  end
end
