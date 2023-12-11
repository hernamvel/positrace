FactoryBot.define do
  factory :url_location do
    url { 'www.google.com' }
    geolocation
  end
end
