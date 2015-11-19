class ManagerAssociation < ActiveRecord::Base
  #Associations
  belongs_to :manager, class_name: :user
  belongs_to :employee, class_name: :user
  
  #Validations
  validates :employee_id, presence: true, numericality: { only_integer: true }
  validates :manager_id, presence: true, numericality: { only_integer: true }
  validate :validate_employee_id, :validate_manager_id

  #Scopes
  scope :active, where("active = ?", true)
  
private

  def validate_employee_id
    errors.add(:employee_id, "is not an employee in our system") unless User.exists?(self.manager_id)
  end

  def validate_manager_id
    errors.add(:manager_id, "is not an employee in our system") unless User.exists?(self.employee_id)
  end
end

