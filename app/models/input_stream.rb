class InputStream < ActiveRecord::Base
  #Associations
  belongs_to :user

  #Validations
  validates :user_id, presence: true, numericality: { only_integer: true }
  #The number 5 is arbitrary and pased on the amount of sensors our design currently implements (4)
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }
  validates :input_time, presence: true
  validates :measurement, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0}

  #Scopes
  scope :last_month, -> { where("created_at > ? and created_at < ?", 30.days.ago, Time.now) }
  scope :by_time, -> { order("created_at DESC") }
  scope :by_set, -> { group("set_id") } 
  scope :by_time_fake, -> { order("input_time DESC") }
  scope :for_user, lambda { |user_id| where("user_id = ?", user_id) }
  #Value for recent is arbitrary, I set it to the past day
  scope :recent, -> { where("created_at > ? and created_at < ?", 10.day.ago, Time.now) }
  # Used in determining posture for small arrays
  scope :by_position, -> { order("position ASC") }

  BACK_POSITIONS = {
    [[1,0],[2,0],[3,1],[4,2]] => 'SB',  # Swayback
    [[1,1],[2,1],[3,0],[4,0]] => 'CPR', # Cradling Phone Receiver
    [[1,2],[2,2],[3,1],[4,2]] => 'NSB', # Not Sitting Back
    [[1,2],[2,2],[3,0],[4,0]] => 'SS',  # Side Sitting
    [[1,2],[2,2],[3,2],[4,2]] => 'GP',  # Good Posture
    [[1,0],[2,0],[3,0],[4,0]] => 'NS'   # Not Sitting
  }
  BACK_POSITIONS.default = 'UK'

  COLOR = {
    'SB' => 'green',
    'UK' => 'yellow',
    'CPR' => 'yellow',
    'NSB' => 'yellow',
    'SS' => 'yellow',
    'GP' => 'green',
    'NS' => 'green'
  }

  POSITION_IMPROVEMENTS = {
    'SB' => ['Push your hips more inward','Strengthen up your back', 'Chin up'],
    'UK' => ['Strengthen up your back', 'Moving only your head, drop your chin down and in toward your sternum while stretching the back of your neck'],
    'CPR' => ['Strengthen up your back','Cradline a phone is bad', 'Have both feet touching the floor', 'Chin up'],
    'NSB' => ['Push your hips inward toward chair','Hips align', 'Strengthen your back', 'Have both feet touching the floor'],
    'SS' => ['Strengthen up your back', 'Try adjusting your body towards desk', 'put your feet in parallel position', 'Chin up'],
    'GP' => ['Good Posture! Keep It Up!','Good Posture! Keep It Up!','Good Posture! Keep It Up!'],
    'NS' => ['Currently not in chair']
  }
  POSITION_IMPROVEMENTS.default = 'Your posture is so bad we seriously dont even know how to fix it'

def self.get_message(hash_table)
   
    while (hash_table.max_by{|k,v| v}[0] == 'NS' || hash_table.max_by{|k,v| v}[0] == 'GP')
       if hash_table.length == 1
   break
       else
         hash_table.delete(hash_table.max_by{|k,v| v})
       end
     end

    return POSITION_IMPROVEMENTS[hash_table.max_by{|k,v| v}[0]]
   end


  #Returns an array of up to three of the most recent input_streams
  def self.find_last_posture_sensors(user)
    position_ids = [1,2,3,4]
    sensor_input = InputStream.for_user(user).by_time #descending order
    # To limit data required when larger amount of data stored
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

  # determine_posture takes in an array of input_streams and returns the posture
  # that they map to.
  def self.determine_posture(sensors)
    total_number_of_sensors = 4
    to_return = 'UK' #Our default value, in case the sensors don't match up

    #Only perform a check when the number of sensors passed to us is correct
    if (sensors.length == total_number_of_sensors)
      posturePreHash = Array.new
      #Convert the input_streams into our hash format
      sensors.each do |s|
        posturePreHash.push([s.position, InputStream.pressurize(s.measurement)])
      end

      #Actually find which one it maps to
      posturePreHash = posturePreHash.sort_by {|i| i.first }
      to_return = BACK_POSITIONS[posturePreHash]
    end
    
    return to_return
  end

  def self.recent_report(user)
    recent_sensors = InputStream.for_user(user).recent.by_time
    postures = InputStream.iterative_posture(recent_sensors, [])
    results= Hash[postures.group_by {|x| x}.map {|k,v| [k,v.count]}]
    return results
  end

   def self.determine_postures(sensor_array)
    postures = Hash.new 
    sensor_array.each do|s|
      postures[s[0].created_at] = InputStream.determine_posture(s)
    end
    return postures
  end

  def self.determine_postures_time(sensor_array)
    postures = Hash.new(Array.new()) 
    sensor_array.each do|s|
      postures[InputStream.determine_posture(s)].push(s[0].created_at)
    end
    return postures
  end
  def self.iterative_posture(sensors, postures)
    if sensors.length < 4
      return postures
    end
    position_ids = [1,2,3,4]
    next_iteration = Array.new
    sensors.each do |i|
      unless position_ids.find_index(i.position).nil?
        position_ids.delete(i.position)
        next_iteration.push(i)
      end

      if next_iteration.length > 3
        sensors = sensors[sensors.index(i),(sensors.length-1)]
        break
      end
    end
    postures << InputStream.determine_posture(next_iteration)
    return  InputStream.iterative_posture(sensors, postures)
  end

  private
  
  def validate_user_id
    errors.add(:user_id, "is not an employee in our system") unless User.exists?(self.user_id)
  end
  
  def self.pressurize(pValue)
    if (pValue == 0)
      return 0
    elsif (pValue < 451)
      return 1
    else 
      return 2
    end
  end
end
