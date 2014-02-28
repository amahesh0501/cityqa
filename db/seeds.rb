# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "csv"

CSV.foreach("db/world_cities.csv") do |row|
  City.create(name: row[0], country: row[2], lat: row[3], long: row[4])
end

cities = City.all

cities.each do |c|
  2.times do
    title = Faker::Lorem.words(10)
    body = Faker::Lorem.paragraph
    c.questions << Question.create!(title: title, body: body)
  end
end

Question.all.each do |q|
  1.times do
    body = Faker::Lorem.sentences
    q.answers << Answer.create!(body: body)
  end
end