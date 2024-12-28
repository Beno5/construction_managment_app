class MachinesController < ApplicationController
  before_action :set_business # Postavi @business iz ApplicationController
  before_action :set_machine, only: [:show, :edit, :update, :destroy]

  def index
    @machines = @business.machines.search(params[:search])

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show; end

  def new
    @machine = @business.machines.new
  end

  def edit; end

  def create
    @machine = @business.machines.new(machine_params)
    if @machine.save
      redirect_to business_machines_path(@business), notice: "Machine was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @machine.update(machine_params)
      redirect_to business_machines_path(@business), notice: "Machine was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @machine.destroy
    redirect_to business_machines_path(@business), notice: "Machine was successfully deleted."
  end

  private

  def set_machine
    @machine = @business.machines.find(params[:id])
  end

  def machine_params
    params.require(:machine).permit(:name, :category, :description, :is_occupied, :hourly_rate)
  end
end
