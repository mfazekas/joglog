class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login

  private

  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def current_user=(user)
    @current_user = user
    if user == nil then
      session[:user_id] = nil
    else
      session[:user_id] = user.id
    end
  end

  def signed_in?
    !!current_user
  end

  def require_login
    if not signed_in?
      flash[:alert] = 'Log in'
      redirect_to new_session_path
    end
  end
end
