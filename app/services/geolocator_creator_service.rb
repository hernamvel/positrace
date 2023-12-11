class GeolocatorCreatorService

  attr_accessor :errors

  def initialize(search_key, search_value)
    @search_key = search_key
    @search_value = search_value
    @errors = []
  end

  # returns geolcation record to be created, otherwise returns nil
  def store
    return unless validate_params

    service = GeolocatorServiceProvider.get_instance
    success, result_from_call = service.fetch(@search_value)
    unless success
      @errors.concat(Array.wrap(result_from_call[:errors]))
      return
    end
    geolocation = Geolocation.new
    geolocation.assign_attributes(result_from_call)
    geolocation.url_locations.build(url: @search_value) if @search_key == "url"
    if geolocation.save
      geolocation
    else
      @errors.concat(@geolocation.errors.map(&:full_message))
    end
  end

  private

  def validate_params
    if @search_value.blank? || !@search_key.in?(%w[ip url])
      @errors << "invalid parameters"
    end
    geolocation = Geolocation.locate_by(@search_key, @search_value)
    if geolocation.present?
      @errors << "record already exists"
    end
    @errors.count == 0
  end
end
