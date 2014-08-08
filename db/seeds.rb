# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# 1.upto(10).each do
#   Manager.create name: Faker::Name.name, email: Faker::Internet.email, password: 'p4ssw0rd', password_confirmation: 'p4ssw0rd'
# end

Club.create short_name: 'ars', name: 'Arsenal'
Club.create short_name: 'av',  name: 'Aston Villa'
Club.create short_name: 'bur', name: 'Burnley'
Club.create short_name: 'che', name: 'Chelsea'
Club.create short_name: 'cp',  name: 'Crystal Palace'
Club.create short_name: 'eve', name: 'Everton'
Club.create short_name: 'hul', name: 'Hull'
Club.create short_name: 'lei', name: 'Leicester'
Club.create short_name: 'liv', name: 'Liverpool'
Club.create short_name: 'mc',  name: 'Manchester City'
Club.create short_name: 'mu',  name: 'Manchester United'
Club.create short_name: 'new', name: 'Newcastle'
Club.create short_name: 'qpr', name: 'Queens Park Rangers'
Club.create short_name: 'sot', name: 'Southampton'
Club.create short_name: 'sto', name: 'Stoke City'
Club.create short_name: 'sun', name: 'Sunderland'
Club.create short_name: 'swa', name: 'Swansea'
Club.create short_name: 'tot', name: 'Tottenham Hotspurs'
Club.create short_name: 'wba', name: 'West Bromwich Albion'
Club.create short_name: 'wh',  name: 'West Ham United'
