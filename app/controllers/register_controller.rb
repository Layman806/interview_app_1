# frozen_string_literal: true

# RegisterController
#   - new: creates new registration for valid data if college and
#           exam with given ids exist.
class RegisterController < ApplicationController
  before_action :check_required_params

  MY_PARAMS = [:first_name, :last_name, :phone_number, :college_id, :exam_id, :start_time]

  def new
    api_request = ApiRequest.create(request_params: params.permit(MY_PARAMS))
    result = api_request.run
    # binding.pry
    unless result
      logger.error "Failed for params: #{params}"
      render json: { status: 'Failure', errors: api_request.errors[:base] },
             status: 400
      return
    end
    render json: { status: 'Success' }, status: 200
  end

  private

  def check_required_params
    params.require(MY_PARAMS)
  end
end
