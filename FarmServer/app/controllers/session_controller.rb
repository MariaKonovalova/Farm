class SessionController
  # To change this template use File | Settings | File Templates.
  def create
    user = User.authenticate(params[:session][:email],
                              params[:session][:password])
    if user.nil?

    else
      session[:user_id] = user.id
      session[:field_id] = Field.find_all_by_user_id(user.id)
    end
  end

  def destroy

  end
end