class NormsController < ApplicationController
  include ActionView::RecordIdentifier

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
                  notice: t("norms.messages.created", default: "Norma uspješno kreirana.")
    else
      flash.now[:alert] = t("norms.messages.validation_error", default: "Molimo provjerite obavezna polja.")
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @norm.update(norm_params)
      redirect_to business_norms_path(@business),
                  notice: t("norms.messages.updated", default: "Norma uspješno ažurirana.")
    else
      flash.now[:alert] = t("norms.messages.validation_error", default: "Molimo provjerite obavezna polja.")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @norm.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to business_norms_path(@business), notice: t("norms.messages.deleted", default: "Norma obrisana.")
      end
    end
  end

  private

  # -------------------------------------------------
  # Business kontekst
  # -------------------------------------------------
  def business_norms
    @norms = current_business.norms.search(params[:search])
    respond_to do |format|
      format.html # standardni HTML prikaz
      format.turbo_stream # Turbo Stream za live pretragu
    end
  end

  # -------------------------------------------------
  # SubTask kontekst (pinovane norme)
  # -------------------------------------------------
  def sub_tasks_norms
    @searched_norms = Norm.search(params[:search])

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
    @business = Business.find(params[:business_id])
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
      :norm_type,
      :subtype,
      :unit_of_measure,
      :norm_value,
      tags: [],
      custom_fields: [:key, :value]
    ).tap do |whitelisted|
      if params[:norm][:custom_fields]
        transformed_custom_fields = params[:norm][:custom_fields].to_unsafe_h.each_with_object({}) do |(_, field), hash|
          key = field["key"].to_s.strip
          value = field["value"].to_s.strip
          hash[key] = value if key.present? && value.present?
        end
        whitelisted[:custom_fields] = transformed_custom_fields
      else
        whitelisted[:custom_fields] = {}
      end
    end
  end
end
