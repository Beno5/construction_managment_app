class WorkersController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :require_business
  before_action :set_business
  before_action :set_worker, only: [:show, :edit, :update, :destroy]

  def index
    @workers = current_business.workers.search(params[:search]).page(params[:worker_page]).per(10)

    respond_to do |format|
      format.html
      format.turbo_stream
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
      full_name = [@worker.first_name, @worker.last_name].compact.join(" ")
      redirect_to business_workers_path(@business), notice: t('workers.messages.created', name: full_name)
    else
      flash.now[:alert] = t('workers.messages.first_name_required')
      render :show, status: :unprocessable_entity
    end
  end

  def update
    # Check optimistic locking if record_updated_at is provided (inline editing)
    if params[:record_updated_at].present?
      # Parse the timestamp sent by client
      record_updated_at = Time.parse(params[:record_updated_at])

      # Truncate both timestamps to second precision to avoid microsecond comparison issues
      record_updated_at_sec = record_updated_at.change(usec: 0)
      worker_updated_at_sec = @worker.updated_at.change(usec: 0)

      # Only flag conflict if database timestamp is NEWER (by more than 1 second)
      # This allows the same user to edit multiple times in the same session
      if worker_updated_at_sec > record_updated_at_sec
        respond_to do |format|
          format.json do
            render json: {
              success: false,
              conflict: true,
              error: 'This record was modified by another user. Please refresh the page.'
            }, status: :conflict
          end
          format.html do
            redirect_to business_workers_path(@business),
                        alert: 'This record was modified by another user. Please refresh the page.'
          end
        end
        return
      end
    end

    if @worker.update(worker_params)
      full_name = [@worker.first_name, @worker.last_name].compact.join(" ")

      respond_to do |format|
        format.json do
          render json: {
            success: true,
            data: {
              id: @worker.id,
              first_name: @worker.first_name,
              last_name: @worker.last_name,
              profession: @worker.profession,
              unit_of_measure: @worker.unit_of_measure,
              price_per_unit: @worker.price_per_unit,
              description: @worker.description,
              custom_fields: @worker.custom_fields,
              updated_at: @worker.updated_at.iso8601
            }
          }, status: :ok
        end
        format.html do
          redirect_to business_workers_path(@business), notice: t('workers.messages.updated', name: full_name)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            success: false,
            errors: @worker.errors.full_messages
          }, status: :unprocessable_entity
        end
        format.html do
          flash.now[:alert] = t('workers.messages.first_name_required')
          render :show, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    full_name = [@worker.first_name, @worker.last_name].compact.join(" ")
    @worker.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to business_workers_path(current_business), notice: t('workers.messages.deleted', name: full_name)
      end
    end
  end

  private

  def set_business
    @business = current_user.businesses.find(params[:business_id])
    @current_business = @business # For backward compatibility with views
  end

  def set_worker
    @worker = @business.workers.find(params[:id])
  end

  def worker_params
    params.require(:worker).permit(
      :first_name, :last_name, :profession, :description,
      :unit_of_measure, :price_per_unit, :is_team,
      custom_fields: {}
    ).tap do |whitelisted|
      if params[:worker][:custom_fields]
        custom_fields_param = params[:worker][:custom_fields].to_unsafe_h

        # Handle two formats:
        # 1. Array format from forms: [{key: "name", value: "val"}, ...]
        # 2. Hash format from inline editing: {field_name: "value"}
        if custom_fields_param.values.first.is_a?(Hash) && custom_fields_param.values.first.key?("key")
          # Array format from forms - replace all custom fields
          transformed_custom_fields = custom_fields_param.each_with_object({}) do |(_, field), hash|
            hash[field["key"]] = field["value"] if field["key"].present? && field["value"].present?
          end
          whitelisted[:custom_fields] = transformed_custom_fields
        else
          # Hash format from inline editing - merge with existing custom fields
          whitelisted[:custom_fields] = (@worker.custom_fields || {}).merge(custom_fields_param)
        end
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end
end
