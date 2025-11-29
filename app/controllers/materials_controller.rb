class MaterialsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :require_business
  before_action :set_business
  before_action :set_material, only: [:show, :edit, :update, :destroy]

  def index
    @materials = current_business.materials.search(params[:search]).page(params[:material_page]).per(10)

    respond_to do |format|
      format.html # Renderuje standardni HTML za klasične prelaze
      format.turbo_stream # Renderuje Turbo Stream za pretragu
    end
  end

  def show; end

  def new
    @material = @business.materials.new
  end

  def edit; end

  def create
    @material = @business.materials.new(material_params)
    @material.user_id = current_user.id

    if @material.save
      redirect_to business_materials_path(@business),
                  notice: t("materials.messages.created", name: @material.name)
    else
      flash.now[:alert] = t('materials.messages.name_required')
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
      material_updated_at_sec = @material.updated_at.change(usec: 0)

      # Only flag conflict if database timestamp is NEWER (by more than 1 second)
      # This allows the same user to edit multiple times in the same session
      if material_updated_at_sec > record_updated_at_sec
        respond_to do |format|
          format.json do
            render json: {
              success: false,
              conflict: true,
              error: 'This record was modified by another user. Please refresh the page.'
            }, status: :conflict
          end
          format.html do
            redirect_to business_materials_path(@business),
                        alert: 'This record was modified by another user. Please refresh the page.'
          end
        end
        return
      end
    end

    if @material.update(material_params)
      respond_to do |format|
        format.json do
          render json: {
            success: true,
            data: {
              id: @material.id,
              name: @material.name,
              unit_of_measure: @material.unit_of_measure,
              price_per_unit: @material.price_per_unit,
              description: @material.description,
              custom_fields: @material.custom_fields,
              updated_at: @material.updated_at.iso8601
            }
          }, status: :ok
        end
        format.html do
          redirect_to business_materials_path(@business),
                      notice: t("materials.messages.updated", name: @material.name)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            success: false,
            errors: @material.errors.full_messages
          }, status: :unprocessable_entity
        end
        format.html do
          flash.now[:alert] = t('materials.messages.name_required')
          render :show, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    name = @material.name
    @material.destroy

    respond_to do |format|
      format.turbo_stream # koristi destroy.turbo_stream.erb
      format.html do
        redirect_to business_materials_path(current_business),
                    notice: t("materials.messages.deleted", name: name)
      end
    end
  end

  private

  def set_business
    @business = current_user.businesses.find(params[:business_id])
    @current_business = @business  # For backward compatibility with views
  end

  def set_material
    @material = @business.materials.find(params[:id])
  end

  def material_params
    params.require(:material).permit(
      :name, :price_per_unit, :unit_of_measure, :description,
      custom_fields: {}
    ).tap do |whitelisted|
      if params[:material][:custom_fields]
        custom_fields_param = params[:material][:custom_fields].to_unsafe_h

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
          whitelisted[:custom_fields] = @material.custom_fields.merge(custom_fields_param)
        end
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end
end
