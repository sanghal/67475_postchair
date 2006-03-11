class ManagerAssociation < ActiveRecord::Base

  belongs_to :manager, class_name: :user
  belongs_to :employee, class_name: :user
  
end
