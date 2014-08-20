desc 'Process Sealed Bids'
task sealed_bids: :environment do

  if SealedBid.count == 0
    puts "\n There are no Sealed Bids!\n\n"
  else
    puts "\n There are #{SealedBid.count} Sealed Bids!\n"

    SealedBid.group(:player_id, :id).order(:player_id).group_by(&:player_id).each do |id,bids|
      bids.sort_by!(&:bid).reverse!
      puts "\n ---> #{bids.first.player}"

      grouped_bids = bids.group_by(&:bid)
      tie = grouped_bids.first.last.count > 1

      grouped_bids.each do |bid,b|
        puts "      £#{bid}m by"
        b.each do |bb|
          puts "       - #{bb.manager}"
        end
      end

      if tie
        puts "    > Bid is tied!"

        league_ids = Team.all.sort_by(&:current_points).reverse.map(&:manager_id)
        p league_ids

        grouped_bids.each_with_index do |bid,i|
          bid.last.each do |bb|
            p bb.manager_id
            p league_ids.index(bb.manager_id)
          end if i == 0
        end

        # Send email to all bidders notifying them of a tie
        # bids.each do |bid|
        #   SealedBidsMailer.tied(bid).deliver
        #   bid.destroy
        # end
      else
        # Send email to the winner
        winner = false
        # bids.each do |bid|
        #   if !winner
        #     winner = bid.manager.team.team_players.build(purchase_price: bid.bid, player: bid.player)
        #     if winner.save
        #       puts "    > Winning bid is £#{bid.bid}m by #{bid.manager}"
        #       SealedBidsMailer.winner(bid).deliver
        #       bid.destroy
        #     else
        #       winner = false
        #       SealedBidsMailer.loser(bid).deliver
        #     end
        #   else
        #     SealedBidsMailer.loser(bid, winner).deliver
        #   end
        # end
      end
    end

    puts "\n"
  end

end