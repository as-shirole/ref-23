class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
  def after_sign_in_path_for(resource)
  	cookies.signed[:user_id] = current_user.id.to_s
  	# cookies.permanent[:user_id]= current_user.id.to_s
  	# cookies[:user_id] = current_user.id.to_s
  	unless cookies.signed[:token_id].nil?
			token = Token.find_by(id: cookies.signed[:token_id])
			token.user_id = current_user.id
			token.save
		end
    chat_rooms_path
  end
end
