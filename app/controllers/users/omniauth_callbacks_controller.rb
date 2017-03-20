class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
      @user = User.from_omniauth(request.env["omniauth.auth"])
      sign_in(:user, @user)
      unless cookies.signed[:token_id].nil?
        token = Token.find_by(id: cookies.signed[:token_id])
        token.user_id = @user.id
        token.save
      end
      @user.first_notification
      redirect_to chat_rooms_path
  end

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in(:user, @user)
    unless cookies.signed[:token_id].nil?
      token = Token.find_by(id: cookies.signed[:token_id])
      token.user_id = @user.id
      token.save
    end
    @user.first_notification
    redirect_to chat_rooms_path
  end
end
