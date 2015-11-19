class InputStream < ActiveRecord::Base
  #Associations
  belongs_to :user

  #Validations
  validates :user_id, presence: true, numericality: { only_integer: true }
  #The number 5 is arbitrary and pased on the amount of sensors our design currently implements (4)
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }
  validates :time, presence: true
  validates_datetime :time
  validates :measurement, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  #Scopes
  scope :by_time, -> { order("time DESC") }
  scope :for_user, lambda { |user_id| where("user_id_id = ?", user_id) }
  #Value for recent is arbitrary, I set it to the past day
  scope :recent, -> { where("time > ? and time < ?", 1.day.ago, Time.now) }
  
  def self.back_positions
    [[1,0],[2,0],[3,1],[3,1],"Swayback"],[[1,0],[2,0],[3,1],[3,1],"Swayback"],[[1,0],[2,0],[3,1],[3,1],"Swayback"],[[1,0],[2,0],[3,1],[3,1],"Swayback"]
  end

  def self.find_last_posture_sensors(user)
    position_ids = [1,2,3,4]
    # To limit data required when larger amount of data stored
    sensor_input = SensorData.for_user(user).by_time
    if sensor_input.length < 4
      return nil
    end

    sensors = Array.new
    sensor_input.each do |i|
      unless position_ids.find_index(i.position).nil?
        position_ids.delete(i.position)
        sensors.push(i)
      end

      if sensors.length > 3
        break
      end
    end
    return sensors
  end

  def self.recent_report(user)
    recent_sensors = SensorData.for_user(user).recent.by_time
  end

  private
    def validate_user_id
      errors.add(:user_id, "is not an employee in our system") unless User.exists?(self.user_id_id)
    end
end
