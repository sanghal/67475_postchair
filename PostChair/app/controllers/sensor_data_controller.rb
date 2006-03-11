class SensorDataController < ApplicationController
  before_action :set_sensor_datum, only: [:show, :edit, :update, :destroy]

  # GET /sensor_data
  # GET /sensor_data.json
  def index
    @sensor_data = SensorDatum.all
  end

  # GET /sensor_data/1
  # GET /sensor_data/1.json
  def show
  end

  # GET /sensor_data/new
  def new
    @sensor_datum = SensorDatum.new
  end

  # GET /sensor_data/1/edit
  def edit
  end

  # POST /sensor_data
  # POST /sensor_data.json
  def create
    @sensor_datum = SensorDatum.new(sensor_datum_params)

    respond_to do |format|
      if @sensor_datum.save
        format.html { redirect_to @sensor_datum, notice: 'Sensor datum was successfully created.' }
        format.json { render :show, status: :created, location: @sensor_datum }
      else
        format.html { render :new }
        format.json { render json: @sensor_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sensor_data/1
  # PATCH/PUT /sensor_data/1.json
  def update
    respond_to do |format|
      if @sensor_datum.update(sensor_datum_params)
        format.html { redirect_to @sensor_datum, notice: 'Sensor datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @sensor_datum }
      else
        format.html { render :edit }
        format.json { render json: @sensor_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sensor_data/1
  # DELETE /sensor_data/1.json
  def destroy
    @sensor_datum.destroy
    respond_to do |format|
      format.html { redirect_to sensor_data_url, notice: 'Sensor datum was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sensor_datum
      @sensor_datum = SensorDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sensor_datum_params
      params.require(:sensor_datum).permit(:user_id_id, :position, :time, :measurement)
    end
end
