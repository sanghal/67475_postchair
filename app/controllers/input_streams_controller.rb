class InputStreamsController < ApplicationController

  require 'net/http'
  before_action :set_input_stream, only: [:show, :edit, :update, :destroy]

  # GET /input_streams
  # GET /input_streams.json
  def index
    @streams = current_user.input_streams.recent
    @input_streams = @streams.group_by { |t| t.set_id}
    @postures = InputStream.determine_postures(@input_streams.values)
    @result = Hash.new(0)
    @postures.each { |prod, value| @result[value] += 1 } 

    
    @good_postures = @postures.select {|key,value| value == "GP"}
    @good_result = Hash.new(0)
    @good_postures.each { |prod, value| @good_result[prod.to_date ] += 1 } 
   #@postures = InputStream.determine_posture(@input_streams.each)

  end

def insertRound
    @input_stream1 = InputStream.new(:measurement=>params["m1"], :position=>1, :user_id=>current_user.id)
    @input_stream2 = InputStream.new(:measurement=>params["m2"], :position=>2, :user_id=>current_user.id)
    @input_stream3 = InputStream.new(:measurement=>params["m3"], :position=>3, :user_id=>current_user.id)
    @input_stream4 = InputStream.new(:measurement=>params["m4"], :position=>4, :user_id=>current_user.id)
    @input_stream1.save
    @input_stream2.save
    @input_stream3.save
    @input_stream4.save
  end

  # GET /input_streams/1
  # GET /input_streams/1.json
  def show
  end
  
  # GET /input_streams/new
  def new
    @input_stream = InputStream.new
  end
  
  # GET /input_streams/1/edit
  def edit
  end
  
  # POST /input_streams
  # POST /input_streams.json
  
  def create
    url = URI.parse('oldeb.res.cmu.edu:3000')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts res.body
    #   @input_stream = InputStream.new(input_stream_params)
    
    #   respond_to do |format|
    #     if @input_stream.save
    #       format.html { redirect_to @input_stream, notice: 'Input stream was successfully created.' }
    #       format.json { render :show, status: :created, location: @input_stream }
    #     else
    #       format.html { render :new }
    #       format.json { render json: @input_stream.errors, status: :unprocessable_entity }
    #     end
    #   end
  end

  end
  #   @input_stream = InputStream.new(input_stream_params)

  #   respond_to do |format|
  #     if @input_stream.save
  #       format.html { redirect_to @input_stream, notice: 'Input stream was successfully created.' }
  #       format.json { render :show, status: :created, location: @input_stream }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @input_stream.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /input_streams/1
  # PATCH/PUT /input_streams/1.json
  def update
    respond_to do |format|
      if @input_stream.update(input_stream_params)
        format.html { redirect_to @input_stream, notice: 'Input stream was successfully updated.' }
        format.json { render :show, status: :ok, location: @input_stream }
      else
        format.html { render :edit }
        format.json { render json: @input_stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /input_streams/1
  # DELETE /input_streams/1.json
  def destroy
    @input_stream.destroy
    respond_to do |format|
      format.html { redirect_to input_streams_url, notice: 'Input stream was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_input_stream
    @input_stream = InputStream.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def input_stream_params
    params.require(:input_stream).permit(:user_id, :position, :input_time, :measurement)
  end
end
