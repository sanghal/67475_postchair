class InputStream < ActiveRecord::Base
  #Associations
  belongs_to :user

  #Validations
  validates :user_id, presence: true, numericality: { only_integer: true }
  #The number 5 is arbitrary and pased on the amount of sensors our design currently implements (4)
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }
  validates :input_time, presence: true
  validates_datetime :input_time
  validates :measurement, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  #Scopes
  scope :by_time, -> { order("input_time DESC") }
  scope :for_user, lambda { |user_id| where("user_id = ?", user_id) }
  #Value for recent is arbitrary, I set it to the past day
  scope :recent, -> { where("input_time > ? and input_time < ?", 1.day.ago, Time.now) }
  # Used in determining posture for small arrays
  scope :by_position, -> { order("position ASC") }
  
<<<<<<< HEAD
  BACK_POSITIONS = {
	[[1,2],[2,2],[3,0],[4,0]] => 'SSH', # Slouch with Shoulder Hunch
	[[1,0],[2,0],[3,1],[4,2]] => 'SB',  # Swayback
	[[1,1],[2,1],[3,0],[4,0]] => 'CPR', # Cradling Phone Receiver
	[[1,2],[2,2],[3,1],[4,2]] => 'NSB', # Not Sitting Back
	[[1,2],[2,2],[3,0],[4,0]] => 'SS',  # Side Sitting
	[[1,2],[2,2],[3,2],[4,2]] => 'GP'   # Good Posutre
  }

  BACK_POSITIONS.default = 'UK'

  def self.find_last_posture_sensors(user)
    position_ids = [1,2,3,4]
    # To limit data required when larger amount of data stored
    sensor_input = InputStream.for_user(user).by_time
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

  def self.determine_posture(sensors)
    if (sensors.length != 4)
	return nil
    end
    posturePreHash = Array.new
    sensors.each do |s|
      posturePreHash.push([s.position, InputStream.pressurize(s.measurement)])
    end
    return BACK_POSITIONS[posturePreHash]
  end

  def self.recent_report(user)
    recent_sensors = InputStream.for_user(user).recent.by_time
  end



  private
    def validate_user_id
      errors.add(:user_id, "is not an employee in our system") unless User.exists?(self.user_id)
    end

    def self.pressurize(pValue)
      if (pValue == 0)
        return 0
      elseif (pValue < 451)
        return 1
      else 
        return 2
      end
    end
end
