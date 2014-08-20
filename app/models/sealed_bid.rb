class SealedBid < ActiveRecord::Base

  belongs_to :player
  belongs_to :manager
  acts_as_paranoid
  validates :bid, presence: true
  validate :valid_bid


  private

    def valid_bid
      if player.sealed_bids.exists? manager: manager
        errors.add :base, 'You have already submitted a bid for this player.'
      end

      if manager.sealed_bids.exists?
        errors.add :base, 'You currently already have a sealed bid tabled. You can only bid once per week.'
      end

      errors.add :bid, 'Bid cannot be more than your current budget.' if bid > manager.team.budget

      teamp = manager.team.team_players.build(purchase_price: bid, player: player)
      errors.add :base, teamp.errors.to_hash.values.first.first unless teamp.valid?
    end

end
