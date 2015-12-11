FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Cena"
    email "johncena@wwe.org"
    password_digest "whocares"
    id 1
  end

  factory :input_stream do
    user_id 0
    set_id 1
    position 1
    input_time DateTime.now
    measurement 0
  end
end
