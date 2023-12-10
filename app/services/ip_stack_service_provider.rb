class IpStackServiceProvider < GeolocatorServiceProvider
  include HTTParty

  base_uri 'api.ipstack.com'

  def initialize(access_credentials)
    super(access_credentials)
  end

  def fetch(ip_address)
    response = self.class.get("/#{ip_address}?access_key=#{@access_credentials}&&hostname=1")
    {
      ip: response.parsed_response['ip'],
      hostname: response.parsed_response['hostname'],
      country_code: response.parsed_response['country_code'],
      country_name: response.parsed_response['country_name'],
      region_code: response.parsed_response['region_code'],
      city: response.parsed_response['city'],
      latitude: response.parsed_response['latitude'],
      longitude: response.parsed_response['longitude']
    }
  end

end