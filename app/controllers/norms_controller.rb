class NormsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :require_business
  before_action :set_business
  before_action :set_norm, only: [:show, :edit, :update, :destroy]

  def index
    if params[:sub_task_id].present?
      sub_tasks_norms
    else
      business_norms
    end
  end

  def show; end

  def new
    @norm = @business.norms.new
  end

  def edit; end

  def create
    @norm = @business.norms.new(norm_params)
    @norm.user_id = current_user.id

    if @norm.save
      redirect_to business_norms_path(@business),
                  notice: t("norms.messages.created", name: @norm.name)
    else
      flash.now[:alert] = t("norms.messages.validation_error")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # Check optimistic locking if record_updated_at is provided (inline editing)
    if params[:record_updated_at].present?
      # Parse the timestamp sent by client
      record_updated_at = Time.parse(params[:record_updated_at])

      # Truncate both timestamps to second precision to avoid microsecond comparison issues
      record_updated_at_sec = record_updated_at.change(usec: 0)
      norm_updated_at_sec = @norm.updated_at.change(usec: 0)

      # Only flag conflict if database timestamp is NEWER (by more than 1 second)
      if norm_updated_at_sec > record_updated_at_sec
        respond_to do |format|
          format.json do
            render json: {
              success: false,
              conflict: true,
              error: t("norms.messages.conflict")
            }, status: :conflict
          end
          format.html do
            redirect_back fallback_location: root_path,
                          alert: t("norms.messages.conflict")
          end
        end
        return
      end
    end

    if @norm.update(norm_params)
      respond_to do |format|
        format.json do
          render json: {
            success: true,
            data: {
              id: @norm.id,
              name: @norm.name,
              unit_of_measure: @norm.unit_of_measure,
              norm_value: @norm.norm_value,
              info: @norm.info,
              info_norm: @norm.info_norm,
              description: @norm.description,
              custom_fields: @norm.custom_fields,
              updated_at: @norm.updated_at.iso8601
            }
          }, status: :ok
        end
        format.html do
          redirect_back fallback_location: root_path,
                        notice: t("norms.messages.updated", name: @norm.name)
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            success: false,
            errors: @norm.errors.full_messages
          }, status: :unprocessable_entity
        end
        format.html do
          render :edit, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    name = @norm.name
    @norm.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to business_norms_path(@business),
                    notice: t("norms.messages.deleted", name: name)
      end
    end
  end

  private

  def update_norms_in_sub_tasks(norm)
    norm.sub_tasks.each do |sub_task|
      SubTaskPlanningCalculator.new(sub_task).call(true)
    end
  end

  # -------------------------------------------------
  # Business kontekst
  # -------------------------------------------------
  def business_norms
    @norms = current_business.norms.search(params[:search]).page(params[:norm_page]).per(10)
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # -------------------------------------------------
  # SubTask kontekst (pinovane norme)
  # -------------------------------------------------
  def sub_tasks_norms
    @searched_norms = Norm.search(params[:search]).page(params[:norm_page]).per(10)

    if params[:sub_task_id].present?
      @sub_task = SubTask.find(params[:sub_task_id])
      @pinned_norms = @sub_task.pinned_norms
      @norms = (@pinned_norms + @searched_norms).uniq
      @norms.sort_by! { |n| @pinned_norms.include?(n) ? 0 : 1 }
    else
      @sub_task = nil
      @pinned_norms = []
      @norms = @searched_norms
    end

    respond_to do |format|
      format.html do
        if turbo_frame_request?
          render partial: "partials/table_norms", locals: {
            norms: @norms,
            sub_task: @sub_task,
            pinned_norms: @pinned_norms
          }
        end
      end
    end
  end

  # -------------------------------------------------
  # Before actions
  # -------------------------------------------------
  def set_business
    @business = current_user.businesses.find(params[:business_id])
    @current_business = @business # For backward compatibility with views
  end

  def set_norm
    @norm = @business.norms.find(params[:id])
  end

  # -------------------------------------------------
  # Strong params
  # -------------------------------------------------
  def norm_params
    params.require(:norm).permit(
      :name,
      :description,
      :info,
      :info_norm,
      :norm_type,
      :subtype,
      :unit_of_measure,
      :norm_value,
      :auto_calculate,
      tags: [],
      custom_fields: {}
    ).tap do |whitelisted|
      if params[:norm][:custom_fields]
        custom_fields_param = params[:norm][:custom_fields].to_unsafe_h

        # Handle two formats:
        # 1. Array format from forms: [{key: "name", value: "val"}, ...]
        # 2. Hash format from inline editing: {field_name: "value"}
        if custom_fields_param.values.first.is_a?(Hash) && custom_fields_param.values.first.key?("key")
          # Array format from forms - replace all custom fields
          transformed_custom_fields = custom_fields_param.each_with_object({}) do |(_, field), hash|
            key = field["key"].to_s.strip
            value = field["value"].to_s.strip
            hash[key] = value if key.present? && value.present?
          end
          whitelisted[:custom_fields] = transformed_custom_fields
        else
          # Hash format from inline editing - merge with existing custom fields
          whitelisted[:custom_fields] = @norm.custom_fields.merge(custom_fields_param)
        end
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end
end
