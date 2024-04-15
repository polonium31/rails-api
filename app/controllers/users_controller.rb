# app/controllers/users_controller.rb

class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy]
  
    # POST /users
    def create
      @user = User.new(user_params)
      if @user.save
        render json: { message: 'Registration successful. Please log in.' }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # POST /login
    def login
      user = User.find_by(email: params[:email])
  
      if user && user.authenticate(params[:password])
        # Set the expiration time (e.g., 1 hour from now)
        expiration_time = Time.now.to_i + (3600 * 3) # 3600 seconds = 1 hour
  
        # Create the payload
        payload = { 
          user_id: user.id,
          exp: expiration_time # This sets the expiration time
        }
        token = JWT.encode(payload, ENV['APP_SECRET_KEY'], 'HS256')
        render json: { message: 'Logged in successfully', token: token }
      else
        render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end
  
    # DELETE /logout
    def logout
      token = extract_token_from_request
      if token
        begin
          # Try to decode the token to check its validity
          payload, _ = JWT.decode(token, ENV['APP_SECRET_KEY'], true, algorithm: 'HS256')
  
          # At this point, the token is considered valid
          # Add expiration to the payload to mark the token as invalid
          payload['exp'] = Time.now.to_i
          new_token = JWT.encode(payload, ENV['APP_SECRET_KEY'], 'HS256')
  
          render json: { message: 'Logged out successfully' }
        rescue JWT::DecodeError
          # JWT::DecodeError is raised when the token is not valid
          render json: { message: 'You need to sign in or sign up before continuing' }, status: :unauthorized
        end
      else
        render json: { message: 'No token found' }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:name, :city, :avatar, :email, :password, :password_confirmation)
    end
  
    def extract_token_from_request
      request.headers['Authorization']&.split&.last
    end
  end
  