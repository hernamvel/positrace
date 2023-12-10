class GeolocatorServiceProvider

  def initialize(access_credentials)
    @access_credentials = access_credentials
  end

  def self.get_instance
    configuration_map = YAML.load(ERB.new(File.read("#{Rails.root}/config/geolocator.yml")).result)
    clazz = "#{configuration_map[Rails.env]["service_provider"]}ServiceProvider".constantize
    clazz.new(configuration_map[Rails.env]["access_key"])
  end

  def fetch(_)
    raise 'should be overriden'
  end
end
