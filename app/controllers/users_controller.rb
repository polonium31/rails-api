class UsersController < ApplicationController
  before_action :authorize_user, except: [:create, :login]

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: { message: 'Registration successful. Please log in.', user: user_without_password_digest(@user) }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      expiration_time = Time.now.to_i + (3600 * 3)
      payload = {
        user_id: user.id,
        exp: expiration_time
      }
      token = JWT.encode(payload, ENV['APP_SECRET_KEY'], 'HS256')
      render json: { message: 'Logged in successfully', token: token, user: user_without_password_digest(user) }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    render json: { user: user_without_password_digest(@user) }
  end

  # PUT /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_update_params)
      render json: { message: 'User updated successfully', user: user_without_password_digest(@user) }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render json: { message: 'User deleted successfully' }
  end

  # GET /users
  def index
    @users = User.all
    render json: { users: @users.map { |user| user_without_password_digest(user) } }
  end
  # DELETE /logout
  def logout
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

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :city, :avatar, :email, :password, :password_confirmation)
  end

  def user_update_params
    params.require(:user).permit(:name, :city, :avatar, :email)
  end

  def extract_token_from_request
    request.headers['Authorization']&.split&.last
  end

  def user_without_password_digest(user)
    user.attributes.except('password_digest')
  end
end
