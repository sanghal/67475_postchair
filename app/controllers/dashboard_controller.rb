class DashboardController < ApplicationController
  before_action :set_input_stream, only: [:show, :edit, :update, :destroy]

  # GET /input_streams
  # GET /input_streams.json
  def index
    @input_streams = InputStream.by_time.limit(4).by_position
    @posture = InputStream.determine_posture(@input_streams)
    @posture_hash = InputStream.recent_report(current_user.id)
    @messages = InputStream.get_message(@posture_hash)
    @color = InputStream::COLOR[@posture]
    @name = InputStream::POSITION_NAME[@posture]
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
