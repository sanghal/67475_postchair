class HistoryController < ApplicationController
  before_action :set_input_stream, only: [:show, :edit, :update, :destroy]

  # GET /input_streams
  # GET /input_streams.json
  def index
    @streams = InputStream.last_month.by_position
    @input_streams = @streams.group_by { |t| t.set_id}
    @postures = InputStream.determine_postures(@input_streams.values)
    @result = Hash.new(0)
    @postures.each { |prod, value| @result[value] += 1 } 
    @good_postures = @postures.select {|key,value| value == "GP"}
    @good_result = Hash.new(0)
    @good_postures.each { |prod, value| @good_result[prod] += 1 } 
    @bad_postures = @postures.each.select { |m| m[0] != "GP" }
    # @postures = InputStream.determine_posture(@input_streams.each)
  end

  # GET /input_streams/1
  # GET /input_streams/1.json
  def show
  end

  # GET /input_streams/new
  def new
  end

  # GET /input_streams/1/edit
  def edit
  end

  # POST /input_streams
  # POST /input_streams.json
  def create
   
  end

  # PATCH/PUT /input_streams/1
  # PATCH/PUT /input_streams/1.json
  def update

  end

  # DELETE /input_streams/1
  # DELETE /input_streams/1.json
  def destroy

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
