require 'json_web_token'

class AuthController < ApplicationController
  def login
    @user = User.find_by(workplace_id: params[:workplace_id])

    if @user.nil?
      error_response = { 
        status: 'error',
        message: 'Workplace ID not found' 
      }
      Rails.logger.warn "Error Response: #{error_response.to_json}"
      render json: error_response, status: :not_found

    elsif !@user.authenticate(params[:password])
      error_response = { 
        status: 'error',
        message: 'Incorrect password' 
      }
      Rails.logger.warn "Error Response: #{error_response.to_json}"
      render json: error_response, status: :unauthorized

    else
      token = JsonWebToken.encode(user_id: @user.id)
      response_data = { 
        status: 'success',
        token: token,
        placeName: @user.name
      }
      Rails.logger.info "Response Data: #{response_data.to_json}"
      render json: response_data
    end
  end
end