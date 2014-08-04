positions = {
  pos1: 'g',
  pos2: 'f',
  pos3: 'c',
  pos4: 'm',
  pos5: 's'
}

metrics = {
  pld: 'played',
  gls: 'goals',
  ass: 'assists',
  cs: 'clean sheets',
  ga: 'goals against'
}


task scrape: :environment do
  agent = Mechanize.new
  page = agent.get('http://localhost:3000/scrapetest/playerlist.html')
  # page = agent.get('http://www.fantasyleague.com/Pro/Stats/playerlist.aspx?dpt=0')
  page.search('#playerlist > .player-list-table > tbody > tr').each do |player|

    # Define position
    position = player.css('td:nth-child(1) div').first[:class].split
    position.delete('pos')
    position = positions[position.first.to_sym]

    # Define name
    name = player.css('td:nth-child(2) a').first
    short_name = name.content

    puts "[#{position.upcase}] #{short_name}"

    full_name, club, image = ''

    begin
      agent.transact do
        player_page = agent.get('http://localhost:3000/scrapetest/player.html')
        # player_page = agent.click name

        content = player_page.search('.content')
        full_name = content.search('> h1').first.content

        content = content.search('> #playerProfile')
        club = content.search('> h4.subheading > a:nth-child(2) strong').first.content
        image = content.search('> img.profile-image').first[:src]

        # Premier League Form
        form = {
          home: metrics,
          away: metrics
        }
        home, away = content.search('#premierLeagueForm tbody tr')
        null, form[:home][:pld], form[:home][:gls], form[:home][:ass], form[:home][:cs], form[:home][:ga] = home.search('td').map do |i|
          i.content.to_i
        end
        null, form[:away][:pld], form[:away][:gls], form[:away][:ass], form[:away][:cs], form[:away][:ga] = away.search('td').map do |i|
          i.content.to_i
        end

        # Fixtures & Results
        player_page.search('#All > table tbody tr').each do |row|
          fixture = {}
          cells = row.search('td')

          fixture[:datetime] = "#{cells[0].content} #{cells[1].content} BST".to_datetime

          opponent, location = cells[3].content.split('(')
          fixture[:opponent] = opponent.strip
          fixture[:location] = location.strip.sub(')', '')
        end

        # Previous seasons
        seasons = {}
        seasons_page = agent.get('http://localhost:3000/scrapetest/player-prev.html')
        # seasons_page = agent.click(player_page.uri.to_s + '?groupid=5')
        seasons_page.search('#PreviousSeasons > table tbody tr').each do |row|
          cells = row.search('td')
          seasons[cells[0].content] = {
            pld: cells[1].content.to_i,
            gls: cells[2].content.to_i,
            ass: cells[3].content.to_i,
            cs: cells[4].content.to_i,
            ga: cells[5].content.to_i
          }
        end
        p seasons
      end
    # rescue => e
    #   $stderr.puts "#{e.class}: #{e.message}"
    end

    puts " Full name: #{full_name}"
    puts " Club: #{club}"
    puts " Image: #{image}"

    exit
  end
end
