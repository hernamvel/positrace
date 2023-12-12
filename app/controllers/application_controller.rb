class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Exceptions::GeoLocationError, with: :server_error

  protected
  def record_not_found(_)
    error_hash = {title: "record not found"}
    render json: {errors: Array.wrap(error_hash)}.to_json, status: 404
  end

  def server_error(exception)
    error_hash = {title: exception.message}
    render json: {errors: Array.wrap(error_hash)}.to_json, status: 500
  end
end
