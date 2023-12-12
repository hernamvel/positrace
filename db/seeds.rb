# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Geolocation.create(ip: '153.253.1.1', country_code: 'co', city: 'Bogota')
Geolocation.create(ip: '153.253.1.2', country_code: 'co', city: 'Bogota')
Geolocation.create(ip: '153.253.1.3', country_code: 'co', city: 'Bogota')
Geolocation.create(ip: '153.253.1.4', country_code: 'co', city: 'Bogota')
Geolocation.create(ip: '153.253.1.5', country_code: 'co', city: 'Bogota')
Geolocation.create(ip: '153.253.1.6', country_code: 'co', city: 'Bogota')
Geolocation.create(ip: '153.253.1.7', country_code: 'co', city: 'Bogota')
Geolocation.create(ip: '172.1.1.20', country_code: 'ca', city: 'Vancouver')
g = Geolocation.create(ip: '35.199.178.49', country_code: 'ca', city: 'Toronto')
UrlLocation.create(url: 'www.positrace.com', geolocation: g)

