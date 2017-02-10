class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      @user = User.from_omniauth(request.env["omniauth.auth"])
      sign_in(:user, @user)
      redirect_to welcome_home_index_path
  end

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in(:user, @user)
    redirect_to welcome_home_index_path
  end
end
