class SealedBidsController < ApplicationController

  before_action :authenticate_manager!
  # before_action :set_player, only: [ :show, :edit, :update, :destroy, :approve ]


  def create
    @sealed_bid = player.sealed_bids.build(sealed_bid_params)
    @sealed_bid.manager = current_manager
    if @sealed_bid.save
      redirect_to player, notice: 'Sealed Bid was successfully submitted. All bids will be opened 11pm Friday.'
    else
      redirect_to @player, alert: "Sealed bid was unsuccessful. #{@sealed_bid.errors.to_hash.values.first.first}"
    end
  end


  private

    def player
      @player ||= Player.find(params[:player_id])
    end

    # Only allow a trusted parameter "white list" through.
    def sealed_bid_params
      params.require(:sealed_bid).permit(:bid)
    end

end