class GeolocationsController < ApplicationController
  before_action :set_geolocation, only: %i[ show ]
  before_action :set_geolocation_by, only: %i[ search_by destroy_by ]

  # GET /geolocations
  def index
    @geolocations = Geolocation.all

    render json: { data: @geolocations }
  end

  # GET /geolocations/1
  def show
    render json: { data: @geolocation }
  end

  # POST /geolocations
  def create
    record = Geolocation.find_by(ip: params[:ip])
    record_to_test = Geolocation.new(ip: params[:ip], hostname: params[:ip])
    if record
      render json: { errors: ["Ip has already been taken"] }, status: :unprocessable_entity
    elsif !record_to_test.valid?
      # Check for formatting validations before going to service locator
      errors = record_to_test.errors.map(&:full_message)
      render json: { errors: errors }, status: :unprocessable_entity
    else
      service = GeolocatorServiceProvider.get_instance
      record_params = service.fetch(params[:ip])
      @geolocation = Geolocation.new(record_params)

      if @geolocation.save
        render json: { data: @geolocation }, status: :created, location: @geolocation
      else
        errors = @geolocation.errors.map(&:full_message)
        render json: { errors: errors }, status: :unprocessable_entity
      end
    end
  end

  # GET /geolocations/search_by
  def search_by
    render json: { data: @geolocation }
  end

  # DELETE /geolocations/destroy_by
  def destroy_by
    @geolocation.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_geolocation
      @geolocation = Geolocation.find(params[:id])
    end

  def set_geolocation_by
    search_hash = %i[ ip hostname ].each_with_object({}) do |field, hash|
      hash[field] = params[field] if params[field].present?
    end
    @geolocation = Geolocation.find_by!(search_hash)
  end
end
