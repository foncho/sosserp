class Users::SessionsController < Devise::SessionsController
  skip_before_filter :validate_user
  
  def create
    user = User.find_by_username(params[:user][:username])
    
    if user && params[:user][:password].present?
      sign_in user
      redirect_to (user.has_any_role?(:user, :admin) ? root_path : expenses_path(user))
    else
      redirect_to user_path(user), alert: user.errors.full_messages.join("<br />").html_safe
    end
  end
end