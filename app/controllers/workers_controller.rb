class WorkersController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_business
  before_action :set_worker, only: [:show, :edit, :update, :destroy]

  def index
    @workers = current_business.workers.search(params[:search])
    respond_to do |format|
      format.html # Renderuje standardni HTML za klasične prelaze
      format.turbo_stream # Renderuje Turbo Stream za pretragu
    end
  end

  def show; end

  def new
    @worker = @business.workers.new
  end

  def edit; end

  def create
    @worker = @business.workers.new(worker_params)
    @worker.user_id = current_user.id
    if @worker.save
      redirect_to business_workers_path(@business), notice: t('workers.messages.created')
    else
      flash.now[:alert] = t('workers.messages.first_name_required')
      render :show, status: :unprocessable_entity 
    end
  end

  def update
    if @worker.update(worker_params)
      redirect_to business_workers_path(@business), notice: t('workers.messages.updated')
    else
      flash.now[:alert] = t('workers.messages.first_name_required')
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    @worker = current_business.workers.find(params[:id])
    @worker.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(dom_id(@worker))
      end
      format.html { redirect_to business_workers_path(current_business), notice: t('workers.messages.deleted') }
    end
  end

  private

  def set_worker
    @worker = @business.workers.find(params[:id])
  end

  def worker_params
    params.require(:worker).permit(
      :first_name, :last_name, :profession, :description,
      :unit_of_measure, :price_per_unit, :is_team,
      custom_fields: [:key, :value]
    ).tap do |whitelisted|
      if params[:worker][:custom_fields]
        # Transformacija custom fields u hash
        transformed_custom_fields = params[:worker][:custom_fields].to_unsafe_h.each_with_object({}) do |(_, field), hash|
          hash[field["key"]] = field["value"] if field["key"].present? && field["value"].present?
        end
        whitelisted[:custom_fields] = transformed_custom_fields
      else
        # Ako `custom_fields` nije prisutan, postavi ga na prazan hash
        whitelisted[:custom_fields] = {}
      end
    end
  end
end
