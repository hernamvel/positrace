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

  # Coming soon when implementing service locator
  # POST /geolocations
  def create
    # @geolocation = Geolocation.new

    # if @geolocation.save
    #   render json: @geolocation, status: :created, location: @geolocation
    # else
    #   render json: @geolocation.errors, status: :unprocessable_entity
    # end
  end

  # GET /geolocations/search_by
  def search_by
    render json: { data: @geolocation }
  end

  # DELETE /geolocations/1
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
