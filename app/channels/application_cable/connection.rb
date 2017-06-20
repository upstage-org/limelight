module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = User.find_by_auth_token(cookies[:auth_token])
    end
  end
end
