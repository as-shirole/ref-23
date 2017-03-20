module ApplicationCable
  class Connection < ActionCable::Connection::Base

  	identified_by :current_user
 
    def connect
    	p "===cookies======#{cookies.class}======="
      unless cookies.signed[:user_id].nil?
        self.current_user = find_verified_user
      end
      p "=========#{self.current_user}======="
    end
 
    private
      def find_verified_user
        if current_user = User.find_by(id: cookies.signed[:user_id])
          current_user
        else
          reject_unauthorized_connection
        end
      end

  end
end


