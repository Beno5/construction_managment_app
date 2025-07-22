class SubTaskPlanningCalculator
  def initialize(sub_task)
    @sub_task = sub_task
    @norms = sub_task.pinned_norms
    @resources = sub_task.activities.where(activity_type: [:worker, :machine])
  end

  def call
    return if @norms.empty? || @resources.empty?

    total_norm_hours = calculate_total_norm_hours
    duration = @sub_task.duration.to_i
    return 0 if duration.zero? || total_norm_hours.zero?

    skilled_norms = @norms.select(&:skilled?)
    unskilled_norms = @norms.select(&:unskilled?)
    machine_norms = @norms.select(&:machine?)

    skilled_data = calculate_cost_and_count(:worker, :skilled, duration)
    unskilled_data = calculate_cost_and_count(:worker, :unskilled, duration)
    machine_data = calculate_cost_and_count(:machine, nil, duration)

    @sub_task.update(
      duration: duration,
      num_workers_skilled: skilled_data[:count],
      num_workers_unskilled: unskilled_data[:count],
      num_machines: machine_data[:count],
      planned_cost: skilled_data[:cost] + unskilled_data[:cost] + machine_data[:cost]
    )
  end

  private

  def calculate_total_norm_hours
    @norms.sum { |norm| norm.norm_value.to_f * @sub_task.quantity.to_f }
  end

  def calculate_cost_and_count(activity_type, _norms, duration)
    relevant_resources = @resources.select { |r| r.activity_type == activity_type.to_s }

    total_cost = 0
    total_count = 0

    relevant_resources.each do |resource|
      hours_per_day = resource.activityable.average_daily_hours
      rate = resource.price_per_unit.to_f
      quantity = resource.quantity.to_i

      total_cost += quantity * hours_per_day * duration * rate
      total_count += quantity
    end

    { cost: total_cost, count: total_count }
  end
end
