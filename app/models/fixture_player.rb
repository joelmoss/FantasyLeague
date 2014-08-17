class FixturePlayer < ActiveRecord::Base

  METRICS = {
    pld: 'played',
    gls: 'goals',
    ass: 'assists',
    cs: 'clean sheets',
    ga: 'goals against',
    tot: 'total'
  }

  belongs_to :fixture
  belongs_to :player

end
