module CustomFieldsHelper
  def render_custom_fields(form, custom_fields)
    render partial: 'partials/custom_fields', locals: { form: form, custom_fields: custom_fields }
  end
end