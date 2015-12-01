namespace :db do 
	desc "Erase and fill database"
	# creating a rake task within db namespace called 'populate'
  	# executing 'rake db:populate' will cause this script to run
  	task :populate => :environment do
  		# Drop the old db and recreate from scratch
	    Rake::Task['db:drop'].invoke
	    Rake::Task['db:create'].invoke
	    # Invoke rake db:migrate
	    Rake::Task['db:migrate'].invoke
	    Rake::Task['db:test:prepare'].invoke
	    # Need gem to make this work when adding students later: faker
	    # Docs at: http://faker.rubyforge.org/rdoc/
	    require 'faker'
	    require 'factory_girl_rails'

	    # Step 1: Create some users 

	    Sangha = FactoryGirl.create(:user, first_name: "Sangha", last_name: "Lee", email: "sangha@gmail.com", password: "sangha", password_confirmation: "sangha")

		positions = [1,2,3,4]
			50.times do
					input_time= Faker::Time.between(DateTime.now - 30, DateTime.now)
					FactoryGirl.create(:input_stream, user_id: Sangha.id, position: 1, measurement: rand(700), input_time: input_time)
					FactoryGirl.create(:input_stream, user_id: Sangha.id, position: 2, measurement: rand(700), input_time: input_time)
					FactoryGirl.create(:input_stream, user_id: Sangha.id, position: 3, measurement: rand(700), input_time: input_time)
					FactoryGirl.create(:input_stream, user_id: Sangha.id, position: 4, measurement: rand(700), input_time: input_time)
				end


	end
end
