class SessionsController < ApplicationController

  def create
    user = User.authenticate(params[:email],
                              params[:password])
    if user.nil?
      render xml: error('User not founded')
    else
      session[:current_user_id] = user.id
      render xml: ok('User founded')
    end
  end

  def destroy
    session[:current_user_id] = null
    render xml: ok('User session deleted')
  end
end
