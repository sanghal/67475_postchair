json.array!(@sensor_data) do |sensor_datum|
  json.extract! sensor_datum, :id, :user_id_id, :position, :time, :measurement
  json.url sensor_datum_url(sensor_datum, format: :json)
end
