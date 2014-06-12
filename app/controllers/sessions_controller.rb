class SessionsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    unless auth = Authentication.find_from_authhash(auth_hash)
      auth=Authentication.create_from_authhash(auth_hash, current_user)
    end
    self.current_user = auth.user
    redirect_to root_url, :notice => "Signed in!"
  end
end