# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

{ "IGIC" => 3, "IVA" => 10 }.each do |key, value|
  Tax.create name: key, value: value
end

puts "Database has been successfully seeded."

#[20, 30, 60, 90].each do |days|
#  PaymentMethod.create days: days
#end