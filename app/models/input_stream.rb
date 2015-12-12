class InputStream < ActiveRecord::Base
  #Associations
  belongs_to :user

  #Validations
  validates :user_id, presence: true, numericality: { only_integer: true }
  #The number 5 is arbitrary and pased on the amount of sensors our design currently implements (4)
  validates :position, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 5 }
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
    if(hash_table.nil? || hash_table.empty?)
      # This happens when the user has no input streams
      return POSITION_IMPROVEMENTS['NS']
    end
   
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


  def self.current_time_seated(user)
  time_between_records = 3 #seconds
  sensors = user.input_streams.by_time

  index = 0
  prev = nil
  sum = 0
  cur = sensors[index]
  while !cur.nil? do
    if(prev.nil?)
      sum += time_between_records
    else
      difference = (((prev.created_at - cur.created_at) * 24 * 60 * 60).to_i)
      if(difference <= time_between_records)
        if(difference != 0)
          sum += time_between_records
        end
      else
        break
      end #if
    end #if
    prev = cur
    index = index + 1
    cur = sensors[index]
  end #while

  ## now convert the sum into a string that also displays number of seconds
  #check if it's in hours
  seconds_in_minute = 60
  seconds_in_hour = seconds_in_minute * 60
  if (sum / seconds_in_hour) > 0
    return "" + (sum / seconds_in_hour).to_s + " hours"
  elsif sum / seconds_in_minute > 0
    return "" + (sum / seconds_in_minute).to_s + " minutes"
  else
    return "" + sum.to_s + " seconds"
  end
end

# Expects current_user.input_streams.recent.by_time
def self.change_over_week(streams)
  times_per_day = [0,0,0,0,0,0,0,0,0,0] # 10 spots because .recent returns last 10 days
  prev_streams = []
  prev_time = DateTime.now
  streams.each do |s|
    index = Date.today - s.created_at.to_date

    #If this is the same as a previous stream, we want to find out if these streams are GP
    if(s.created_at == prev_time)
      prev_streams << s
      #If they are good posture, increment the amount of good posture that day by 3
      if InputStream.determine_posture(prev_streams) == "GP"
        times_per_day[index] += 3
      end
    else
      #if it was different, set up the next round
      prev_time = s.created_at
      prev_streams = [s]
    end
  end

  #Now that we're here, we have the number of good postures per day and need to calculate increase
  differences_per_day = 0.0
  #want to operate from oldest day to newest, so flip array
  times_per_day.reverse!
  #we have ten items, so need to index 3 in to get to 7 days ago
  prev_times = times_per_day[3]
  #Need to exclude first four, so countdown
  countdown = 4
  times_per_day.each do |t|
    if countdown > 0
      countdown -= 1
    else
      differences_per_day += (t - prev_times) > 0 ? (t - prev_times) : 0
      prev_times = t
    end
  end
  differences_per_day = differences_per_day / 7.0
  return (differences_per_day.to_i.to_f == differences_per_day ? differences_per_day.to_i : differences_per_day.round(2)).to_s + "%"
end

end
