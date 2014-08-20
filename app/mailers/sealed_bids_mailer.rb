class SealedBidsMailer < ActionMailer::Base
  default from: "joel@developwithstyle.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sealed_bids_mailer.tied.subject
  #
  def tied(bid)
    @bid = bid
    mail to: bid.manager.email, subject: 'Your Sealed Bid was a tie!'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sealed_bids_mailer.winner.subject
  #
  def winner(bid)
    @bid = bid
    mail to: bid.manager.email, subject: 'You won your Sealed Bid!'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sealed_bids_mailer.winner.subject
  #
  def loser(bid, winner)
    @bid, @winner = bid, winner
    mail to: bid.manager.email, subject: 'You lost your Sealed Bid!'
  end
end
