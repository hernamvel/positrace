FactoryBot.define do
  factory :geolocation do
    ip { '127.0.0.1' }
    country_code { 'us' }
    country_name { 'United States'}
    region_code { 'Florida' }
    city { 'Miami' }
    latitude { 25 }
    longitude { -80 }
  end
end
