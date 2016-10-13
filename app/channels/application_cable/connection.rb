module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    
    def connected
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.email
    end
    
    protected
    def find_verified_user # checks whether a user is authenticated with devise
      if (current_user = User.find_by_id cookies.signed['user.id'])
      else
        reject_unauthorized_connection
      end
    end
  end
end
