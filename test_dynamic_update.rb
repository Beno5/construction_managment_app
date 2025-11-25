require "securerandom"

puts "\n=== START TEST UPDATE_DYNAMIC_ATTRIBUTES_SERVICE ===\n\n"

# Run inside Rails (bin/rails runner test_dynamic_update.rb)
# To avoid FK conflicts with existing data, we create fresh user/business records each run.
suffix   = SecureRandom.hex(4)
user     = User.create!(email: "test-#{suffix}@example.com", password: "password", terms: true)
business = Business.create!(name: "Test Biz #{suffix}", user: user, currency: :euro)

puts "Creating project..."
project = Project.create!(
  name: "Test Project",
  business: business,
  user: user,
  planned_start_date: Date.new(2025, 1, 1),
  planned_end_date: Date.new(2025, 1, 10),
  planned_cost: 0
)
puts "Project: #{project.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}\n\n"

# 1) Task
puts "Creating task 1..."
task = Task.create!(
  name: "Task 1",
  project: project,
  user: user,
  planned_start_date: Date.new(2025, 1, 1),
  planned_end_date: Date.new(2025, 1, 30),
  planned_cost: 0
)
puts "Task: #{task.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}"
puts "Project after task: #{project.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}\n\n"

# 2) SubTask A
puts "Creating SubTask A..."
sub_a = SubTask.create!(
  name: "Sub A",
  task: task,
  user: user,
  planned_start_date: Date.new(2025, 1, 5),
  planned_end_date: Date.new(2025, 1, 7),
  planned_cost: 100
)
puts "Task after Sub A: #{task.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}"
puts "Project after Sub A: #{project.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}\n\n"

# 3) SubTask B
puts "Creating SubTask B..."
sub_b = SubTask.create!(
  name: "Sub B",
  task: task,
  user: user,
  planned_start_date: Date.new(2025, 1, 10),
  planned_end_date: Date.new(2025, 1, 20),
  planned_cost: 300
)
puts "Task after Sub B: #{task.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}"
puts "Project after Sub B: #{project.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}\n\n"

# 4) Update Sub A
puts "Updating Sub A dates and cost..."
sub_a.update!(
  planned_start_date: Date.new(2025, 1, 2),
  planned_end_date: Date.new(2025, 1, 25),
  planned_cost: 500
)
puts "Task after Sub A update: #{task.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}"
puts "Project after Sub A update: #{project.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}\n\n"

# 5) Destroy Sub B
puts "Destroying Sub B..."
sub_b.destroy!
puts "Task after Sub B destroy: #{task.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}"
puts "Project after Sub B destroy: #{project.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}\n\n"

# 6) Destroy Sub A
puts "Destroying Sub A (no subtasks remain; values stay as last calculated)..."
sub_a.destroy!
puts "Task after all subtasks removed: #{task.reload.slice(:planned_start_date, :planned_end_date, :planned_cost)}"
puts "Project after all subtasks removed: #{project.reload.slice(:planned_start_date, :planned_end_date,
                                                                 :planned_cost)}\n\n"

puts "=== TEST DONE ==="
