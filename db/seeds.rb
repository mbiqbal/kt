# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development?
  company = Company.create(name: 'Umbrella Corps')
  Vehicle.create!(registration_name: "4567898765", company: company)
  User.admin.create!(name: "Admin User", company: company)
  User.read_only.create!(name: "Readonly User", company: company)
end
