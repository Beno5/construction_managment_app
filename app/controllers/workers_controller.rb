class WorkersController < ApplicationController
  before_action :set_business
  before_action :set_worker, only: [:show, :edit, :update, :destroy]

  # List all workers for the current business
  def index
    @workers = @business.workers
    # Breadcrumbs automatski dodaje:
    # Businesses → Test Business → Workers
  end

  # Display a single worker
  def show
    # Breadcrumbs automatski dodaje:
    # Businesses → Test Business → Workers → John Doe
  end

  # Show the form for creating a new worker
  def new
    @worker = @business.workers.new
    # Breadcrumbs automatski dodaje:
    # Businesses → Test Business → Workers → New Worker
  end

  # Show the form for editing a worker
  def edit
    # Breadcrumbs automatski dodaje:
    # Businesses → Test Business → Workers → Edit Worker
  end

  # Create a new worker
  def create
    @worker = @business.workers.new(worker_params)
    if @worker.save
      redirect_to business_workers_path(@business), notice: 'Worker was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Update an existing worker
  def update
    if @worker.update(worker_params)
      redirect_to business_workers_path(@business), notice: 'Worker was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Delete a worker
  def destroy
    @worker.destroy
    redirect_to business_workers_path(@business), notice: 'Worker was successfully deleted.'
  end

  private

  # Set the current business
  def set_business
    @business = current_user.businesses.find(params[:business_id])
    # Breadcrumbs automatski dodaje "Test Business"
  end

  # Find the worker within the current business
  def set_worker
    @worker = @business.workers.find(params[:id])
    # Breadcrumbs automatski dodaje "John Doe" za radnika
  end

  # Allow only permitted parameters for a worker
  def worker_params
    params.require(:worker).permit(
      :first_name,
      :last_name,
      :profession,
      :description,
      :hired_on,
      :salary,
      :hourly_rate,
      :contract_hours_per_month,
      :phone_number
    )
  end
end
