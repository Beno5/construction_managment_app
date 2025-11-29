module SubTasksHelper
  def formatted_duration_days_hours(decimal_days, business = nil)
    return I18n.t('subtasks.duration.not_set') if decimal_days.blank?

    hours_per_day = business&.working_hours_per_day_or_default || Business.column_defaults["working_hours_per_day"] || 9.0
    hours_per_day = hours_per_day.to_f

    # Support both dot and comma decimal separators
    decimal = decimal_days.is_a?(Numeric) ? decimal_days.to_f : decimal_days.to_s.tr(',', '.').to_f

    return decimal_days.to_s unless hours_per_day.positive?

    whole_days = decimal.floor
    remaining_hours = ((decimal - whole_days) * hours_per_day).round

    if remaining_hours >= hours_per_day
      whole_days += 1
      remaining_hours = 0
    end

    I18n.t('subtasks.duration.formatted', days: whole_days, hours: remaining_hours)
  end
end
