class MachinesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :require_business
  before_action :set_business
  before_action :set_machine, only: [:show, :edit, :update, :destroy]

  def index
    @machines = current_business.machines.search(params[:search]).page(params[:machine_page]).per(10)
    respond_to do |format|
      format.html # Renderuje standardni HTML za klasične prelaze
      format.turbo_stream # Renderuje Turbo Stream za pretragu
    end
  end

  def show; end

  def new
    @machine = @business.machines.new
  end

  def edit; end

  def create
    @machine = @business.machines.new(machine_params)
    @machine.user_id = current_user.id

    if @machine.save
      redirect_to business_machines_path(@business),
                  notice: t("machines.messages.created", name: @machine.name)
    else
      flash.now[:alert] = t('machines.messages.name_required')
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
      machine_updated_at_sec = @machine.updated_at.change(usec: 0)

      # Only flag conflict if database timestamp is NEWER (by more than 1 second)
      # This allows the same user to edit multiple times in the same session
      if machine_updated_at_sec > record_updated_at_sec
        respond_to do |format|
          format.json do
            render json: {
              success: false,
              conflict: true,
              error: 'This record was modified by another user. Please refresh the page.'
            }, status: :conflict
          end
          format.html do
            redirect_to business_machines_path(@business),
                        alert: 'This record was modified by another user. Please refresh the page.'
          end
        end
        return
      end
    end

    if @machine.update(machine_params)
      respond_to do |format|
        format.json do
          render json: {
            success: true,
            data: {
              id: @machine.id,
              name: @machine.name,
              unit_of_measure: @machine.unit_of_measure,
              price_per_unit: @machine.price_per_unit,
              fixed_costs: @machine.fixed_costs,
              description: @machine.description,
              custom_fields: @machine.custom_fields,
              updated_at: @machine.updated_at.iso8601
            }
          }, status: :ok
        end
        format.html do
          redirect_to business_machines_path(@business),
                      notice: t("machines.messages.updated", name: @machine.name)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            success: false,
            errors: @machine.errors.full_messages
          }, status: :unprocessable_entity
        end
        format.html do
          flash.now[:alert] = t('machines.messages.name_required')
          render :show, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    name = @machine.name
    @machine.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to business_machines_path(current_business),
                    notice: t("machines.messages.deleted", name: name)
      end
    end
  end

  private

  def set_business
    @business = current_user.businesses.find(params[:business_id])
    @current_business = @business # For backward compatibility with views
  end

  def set_machine
    @machine = @business.machines.find(params[:id])
  end

  def machine_params
    params.require(:machine).permit(
      :name, :unit_of_measure, :price_per_unit, :fixed_costs, :description,
      custom_fields: {}
    ).tap do |whitelisted|
      if params[:machine][:custom_fields]
        custom_fields_param = params[:machine][:custom_fields].to_unsafe_h

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
          whitelisted[:custom_fields] = @machine.custom_fields.merge(custom_fields_param)
        end
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end
end
