module Contexts
  module UserContext

    def create_one_user_context
      @user1 = FactoryGirl.create(:user)
    end

    def delete_one_user_context
      @user1.delete
    end
    
  end
end
