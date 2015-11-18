class ManagerAssociationsController < ApplicationController
  before_action :set_manager_association, only: [:show, :edit, :update, :destroy]

  # GET /manager_associations
  # GET /manager_associations.json
  def index
    @manager_associations = ManagerAssociation.all
  end

  # GET /manager_associations/1
  # GET /manager_associations/1.json
  def show
  end

  # GET /manager_associations/new
  def new
    @manager_association = ManagerAssociation.new
  end

  # GET /manager_associations/1/edit
  def edit
  end

  # POST /manager_associations
  # POST /manager_associations.json
  def create
    @manager_association = ManagerAssociation.new(manager_association_params)

    respond_to do |format|
      if @manager_association.save
        format.html { redirect_to @manager_association, notice: 'Manager association was successfully created.' }
        format.json { render :show, status: :created, location: @manager_association }
      else
        format.html { render :new }
        format.json { render json: @manager_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /manager_associations/1
  # PATCH/PUT /manager_associations/1.json
  def update
    respond_to do |format|
      if @manager_association.update(manager_association_params)
        format.html { redirect_to @manager_association, notice: 'Manager association was successfully updated.' }
        format.json { render :show, status: :ok, location: @manager_association }
      else
        format.html { render :edit }
        format.json { render json: @manager_association.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager_associations/1
  # DELETE /manager_associations/1.json
  def destroy
    @manager_association.destroy
    respond_to do |format|
      format.html { redirect_to manager_associations_url, notice: 'Manager association was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manager_association
      @manager_association = ManagerAssociation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manager_association_params
      params.require(:manager_association).permit(:manager_id, :employee_id, :active, :boolean)
    end
end
