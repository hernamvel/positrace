class ApplicationController < ActionController::API

  rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found

  protected
  def record_not_found(exception)
    error_hash = {title: exception.message}
    render json: {errors: Array.wrap(error_hash)}.to_json, status: 404
    return
  end
end
