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
    service = GeolocatorCreatorService.new(params[:search_key], params[:search_value])
    @geolocation = service.store
    if @geolocation.present?
      render json: { data: @geolocation }, status: :created, location: @geolocation
    else
      render json: { errors: service.errors }, status: :unprocessable_entity
    end
  end

  # GET /geolocations/search_by
  def search_by
    render json: { data: @geolocation }
  end

  # DELETE /geolocations/destroy_by
  def destroy_by
    ActiveRecord::Base.transaction do
      @geolocation.url_locations.each do |record|
        record.destroy!
      end
      @geolocation.destroy!
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_geolocation
      @geolocation = Geolocation.find(params[:id])
    end

  def set_geolocation_by
    @geolocation = Geolocation.locate_by(params[:search_key], params[:search_value])
    raise ActiveRecord::RecordNotFound if @geolocation.nil?
  end
end
