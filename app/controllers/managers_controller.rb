class ManagersController < ApplicationController

  before_action :authenticate_manager!
  before_action :set_manager, only: [ :show, :edit, :update, :destroy ]


  # GET /managers
  def index
    @managers = Manager.all
  end

  # GET /managers/1
  def show
  end

  # GET /managers/new
  def new
    @manager = Manager.new
  end

  # GET /managers/1/edit
  def edit
  end

  # POST /managers
  def create
    @manager = Manager.new(manager_params)

    if @manager.save
      redirect_to @manager, notice: 'Manager was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /managers/1
  def update
    if @manager.update(manager_params)
      redirect_to @manager, notice: 'Manager was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /managers/1
  def destroy
    @manager.destroy
    redirect_to managers_url, notice: 'Manager was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manager
      @manager = Manager.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def manager_params
      params[:manager]
    end
end
