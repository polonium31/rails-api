class Auth::SessionsController < ApplicationController
    def create
      user = User.find_by(email: params[:email])
  
      if user && user.authenticate(params[:password])
          expiration_time = Time.now.to_i + (3600 * 3)
  
          payload = { 
              user_id: user.id,
              exp: expiration_time
          }
          token = JWT.encode(payload, ENV['APP_SECRET_KEY'], 'HS256')
          render json: { message: 'Logged in successfully', token: token }
      else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end
  
    def destroy
      token = extract_token_from_request
      if token
        begin
          payload, _ = JWT.decode(token, ENV['APP_SECRET_KEY'], true, algorithm: 'HS256')
  
          payload['exp'] = Time.now.to_i
          new_token = JWT.encode(payload, ENV['APP_SECRET_KEY'], 'HS256')
  
          render json: { message: 'Logged out successfully' }
        rescue JWT::DecodeError
          render json: { message: 'You need to sign in or sign up before continuing' }, status: :unauthorized
        end
      else
        render json: { message: 'No token found' }, status: :unprocessable_entity
      end
    end
  
    private
  
    def extract_token_from_request
      request.headers['Authorization']&.split&.last
    end
  end
  