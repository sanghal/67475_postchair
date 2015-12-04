module Contexts
  module InputStreamsContext
    
    # for use with other contexts/tests
    def create_one_input_stream_set
      @set_ns = [FactoryGirl.create(:input_stream),
                  FactoryGirl.create(:input_stream, position: 2),
                  FactoryGirl.create(:input_stream, position: 3),
                  FactoryGirl.create(:input_stream, position: 4)]
    end

    def delete_one_input_stream_set
      if @set_ns
        @set_ns.map(&:destroy)
        @set_ns = nil
      end
    end

    def create_input_streams_sets
      create_one_input_stream_set
      
      @set_sb = [FactoryGirl.create(:input_stream, set_id: 67477),
                 FactoryGirl.create(:input_stream, position: 2, set_id: 67477),
                 FactoryGirl.create(:input_stream, position: 3, set_id: 67477, measurement: 1),
                 FactoryGirl.create(:input_stream, position: 4, set_id: 67477, measurement: 452)]
      @set_cpr = [FactoryGirl.create(:input_stream, set_id: 67478, measurement: 1),
                  FactoryGirl.create(:input_stream, position: 2, set_id: 67478, measurement: 1),
                  FactoryGirl.create(:input_stream, position: 3, set_id: 67478),
                  FactoryGirl.create(:input_stream, position: 4, set_id: 67478)]
      @set_nsb = [FactoryGirl.create(:input_stream, set_id: 67478, measurement: 452),
                  FactoryGirl.create(:input_stream, position: 2, set_id: 67478, measurement: 452),
                  FactoryGirl.create(:input_stream, position: 3, set_id: 67478, measurement: 1),
                  FactoryGirl.create(:input_stream, position: 4, set_id: 67478, measurement: 452)]
      @set_ss = [FactoryGirl.create(:input_stream, set_id: 67478, measurement: 452),
                 FactoryGirl.create(:input_stream, position: 2, set_id: 67478, measurement: 452),
                 FactoryGirl.create(:input_stream, position: 3, set_id: 67478),
                 FactoryGirl.create(:input_stream, position: 4, set_id: 67478)]
      @set_gp = [FactoryGirl.create(:input_stream, set_id: 67476, measurement: 452),
                 FactoryGirl.create(:input_stream, position: 2, set_id: 67476, measurement: 452),
                 FactoryGirl.create(:input_stream, position: 3, set_id: 67476, measurement: 452),
                 FactoryGirl.create(:input_stream, position: 4, set_id: 67476, measurement: 452)]
      @set_uk = [FactoryGirl.create(:input_stream, set_id: 67476, measurement: 1),
                 FactoryGirl.create(:input_stream, position: 2, set_id: 67476, measurement: 452),
                 FactoryGirl.create(:input_stream, position: 3, set_id: 67476, measurement: 1),
                 FactoryGirl.create(:input_stream, position: 4, set_id: 67476, measurement: 452)]
    end

    def delete_input_streams_sets
      [@set_ns, @set_sb, @set_cpr, @set_nsb, @set_ss, @set_gp, @set_uk].each do |set|
        if set
          set.map(&:destroy)
          set = nil
        end
      end
    end

  end
end                                                                      
