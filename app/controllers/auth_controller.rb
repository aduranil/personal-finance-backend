class AuthController < ApplicationController

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      render json: {username: user.username, id: user.id, token: issue_token({id: user.id})}
    else
      render({json: {error: 'Wrong username or password'}, status: 401})
    end
  end

  def show
    if current_user
      render json: current_user
    else
      render json: {error: 'Invalid token'}, status: 401
    end
  end


end
