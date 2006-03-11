class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :managers, through: :manager_association, class_name: :user
  has_many :employees, through: :manager_association, class_name: :user
  
end
