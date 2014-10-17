## Notes...

### Transfer player from team to team

    TeamPlayer.find(1).update team_id: 3, purchase_price: 0

### View sealed bids

    SealedBid.all.sort_by(&:player_id).each {|sb| p sb.player_id.to_s + ' - ' + sb.bid.to_s + ' / ' + sb.manager.team.to_s}