class ApplicationController < ActionController::API

  def issue_token(payload)
    JWT.encode(payload, ENV['secret_thing'], 'HS256')
  end

  def current_user
    @user ||= User.find_by(id: user_id)
  end

  def user_id
    decoded_token.first['id']
  end

  def decoded_token
    begin
       JWT.decode(request.headers['Authorization'], ENV['secret_thing'], true, { :algorithm => 'HS256' })
     rescue JWT::DecodeError
      [{}]
     end
  end

  def logged_in?
    !!current_user
  end
end
