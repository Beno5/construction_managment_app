namespace :inline_edit do
  desc "Add inline editing support to remaining controllers (Tasks, SubTasks, Norms)"
  task add_to_controllers: :environment do
    controllers = [
      {
        file: 'app/controllers/tasks_controller.rb',
        model_name: 'task',
        model_class: 'Task',
        instance_var: '@task',
        fields: [:name, :position, :planned_start_date, :planned_end_date, :status, :description]
      },
      {
        file: 'app/controllers/sub_tasks_controller.rb',
        model_name: 'sub_task',
        model_class: 'SubTask',
        instance_var: '@sub_task',
        fields: [:name, :position, :planned_start_date, :planned_end_date, :duration, :description]
      },
      {
        file: 'app/controllers/norms_controller.rb',
        model_name: 'norm',
        model_class: 'Norm',
        instance_var: '@norm',
        fields: [:name, :code, :unit_of_measure, :quantity, :price_per_unit, :description]
      }
    ]

    controllers.each do |controller_info|
      file_path = Rails.root.join(controller_info[:file])
      next unless File.exist?(file_path)

      content = File.read(file_path)

      # Check if already has optimistic locking
      if content.include?('record_updated_at')
        puts "✓ #{controller_info[:file]} already has inline editing support"
        next
      end

      # Find the update method
      if content =~ /(  def update\n.*?)(  def \w+|\z)/m
        original_update = Regexp.last_match(1)
        Regexp.last_match(2)

        # Generate the new update method
        new_update = generate_update_method(controller_info)

        # Replace the update method
        new_content = content.sub(original_update, new_update)

        # Write back
        File.write(file_path, new_content)
        puts "✓ Updated #{controller_info[:file]}"
      else
        puts "✗ Could not find update method in #{controller_info[:file]}"
      end
    end

    puts "\n✅ Controller updates complete!"
    puts "Next steps:"
    puts "1. Update views to add inline editing data attributes"
    puts "2. Run: yarn build"
    puts "3. Run: rake assets:precompile"
  end

  def generate_update_method(info)
    model_var = info[:instance_var]
    model_name = info[:model_name]

    fields_json = info[:fields].map { |f| "#{f}: #{model_var}.#{f}" }.join(",\n              ")

    <<~RUBY
      def update
        # Check optimistic locking if record_updated_at is provided (inline editing)
        if params[:record_updated_at].present?
          # Parse the timestamp sent by client
          record_updated_at = Time.parse(params[:record_updated_at])

          # Truncate both timestamps to second precision to avoid microsecond comparison issues
          record_updated_at_sec = record_updated_at.change(usec: 0)
          #{model_name}_updated_at_sec = #{model_var}.updated_at.change(usec: 0)

          # Only flag conflict if database timestamp is NEWER (by more than 1 second)
          if #{model_name}_updated_at_sec > record_updated_at_sec
            respond_to do |format|
              format.json do
                render json: {
                  success: false,
                  conflict: true,
                  error: 'This record was modified by another user. Please refresh the page.'
                }, status: :conflict
              end
              format.html do
                redirect_back fallback_location: root_path,
                              alert: 'This record was modified by another user. Please refresh the page.'
              end
            end
            return
          end
        end

        if #{model_var}.update(#{model_name}_params)
          respond_to do |format|
            format.json do
              render json: {
                success: true,
                data: {
                  id: #{model_var}.id,
                  #{fields_json},
                  updated_at: #{model_var}.updated_at.iso8601
                }
              }, status: :ok
            end
            format.html do
              redirect_back fallback_location: root_path,
                            notice: "#{info[:model_class]} was successfully updated."
            end
          end
        else
          respond_to do |format|
            format.json do
              render json: {
                success: false,
                errors: #{model_var}.errors.full_messages
              }, status: :unprocessable_entity
            end
            format.html do
              render :edit, status: :unprocessable_entity
            end
          end
        end
      end

    RUBY
  end
end
