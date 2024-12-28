class WorkersController < ApplicationController
  before_action :set_business
  before_action :set_worker, only: [:show, :edit, :update, :destroy]

  def index
    @workers = current_business.workers.search(params[:search])
    respond_to do |format|
      format.html # standardna HTML stranica
      format.turbo_stream # odgovori sa Turbo Stream-om za live update
    end
  end

  def show; end

  def new
    @worker = @business.workers.new
  end

  def edit; end

  def create
    @worker = @business.workers.new(worker_params)
    if @worker.save
      redirect_to business_workers_path(@business), notice: 'Worker was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @worker.update(worker_params)
      redirect_to business_workers_path(@business), notice: 'Worker was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @worker.destroy
    redirect_to business_workers_path(@business), notice: 'Worker was successfully deleted.'
  end

  private

  def set_worker
    @worker = @business.workers.find(params[:id])
  end

  def worker_params
    params.require(:worker).permit(:first_name, :last_name, :profession, :description, :hired_on, :salary,
                                   :hourly_rate, :contract_hours_per_month, :phone_number)
  end
end
