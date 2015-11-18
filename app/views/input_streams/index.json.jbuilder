json.array!(@input_streams) do |input_stream|
  json.extract! input_stream, :id, :user_id, :position, :input_time, :measurement
  json.url input_stream_url(input_stream, format: :json)
end
