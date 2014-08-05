class ManagersController < ApplicationController

  before_action :authenticate_manager!
  before_action :set_manager, only: [ :show, :edit, :update, :destroy, :approve ]

  add_breadcrumb 'Managers', :managers_path


  # GET /managers
  def index
    @managers = current_manager.admin? ? Manager.all.order(:approved) : Manager.all.approved
  end

  # GET /managers/1
  def show
    add_breadcrumb @manager, @manager
  end

  # GET /managers/1/edit
  def edit
    add_breadcrumb @manager, @manager
    add_breadcrumb 'Edit', [:edit, @manager]
  end

  # PATCH/PUT /managers/1
  def update
    if @manager.update(manager_params)
      redirect_to @manager, notice: 'Manager was successfully updated.'
    else
      render :edit
    end
  end

  def approve
    if @manager.update(approved: true)
      redirect_to :back, notice: 'Manager was successfully approved.'
    else
      render @manager
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
      @manager = if current_manager.admin?
        Manager.find(params[:id])
      else
        Manager.approved.find(params[:id])
      end
    end

    # Only allow a trusted parameter "white list" through.
    def manager_params
      params.require(:manager).permit(:name, :email)
    end

end
