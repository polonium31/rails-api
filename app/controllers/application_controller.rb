class ApplicationController < ActionController::API
    include TokenHelper
  
    before_action :authorize_user
  
    private
  
    def authorize_user
      token = request.headers['Authorization']&.split&.last
      payload = decode_token(token)
      if payload.nil?
        render json: { error: 'Unauthorized' }, status: :unauthorized
      else
        @current_user = User.find(payload['user_id'])
      end
    end
  end
  