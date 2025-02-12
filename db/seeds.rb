# Brisanje postojećih podataka (opcionalno, paziti u produkciji!)
Activity.destroy_all
Link.destroy_all
Task.destroy_all
Project.destroy_all
Material.destroy_all
Machine.destroy_all
Worker.destroy_all
Business.destroy_all
User.destroy_all

# Kreiranje korisnika bez poslovanja (npr. admin user)
User.create!(
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password"
)

# Kreiranje korisnika sa poslovanjem
user = User.create!(
  email: "test@example.com",
  password: "password",
  password_confirmation: "password"
)

# Kreiranje poslovanja za korisnika
business = Business.create!(
  name: Faker::Company.name, # Nasumično ime poslovanja
  address: Faker::Address.full_address, # Nasumična puna adresa
  phone_number: Faker::PhoneNumber.phone_number, # Nasumični broj telefona
  user: user
)

# Kreiranje materijala
10.times do
  Material.create!(
    name: Faker::Construction.material,
    price_per_unit: Faker::Number.decimal(l_digits: 2, r_digits: 2),
    unit_of_measure: %w[kg m3 pcs].sample,
    description: Faker::Lorem.sentence,
    custom_fields: { supplier: Faker::Company.name },
    business: business
  )
end

# Kreiranje mašina
10.times do
  Machine.create!(
    name: Faker::Appliance.equipment,
    category: Faker::Appliance.brand,
    description: Faker::Lorem.sentence,
    is_occupied: [true, false].sample,
    machine_type: Faker::Construction.heavy_equipment,
    business: business
  )
end

# Kreiranje radnika
10.times do
  Worker.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    profession: Faker::Job.title,
    description: Faker::Lorem.sentence,
    hired_on: Faker::Date.backward(days: 365),
    salary: Faker::Number.decimal(l_digits: 4, r_digits: 2),
    hourly_rate: Faker::Number.decimal(l_digits: 2, r_digits: 2),
    contract_hours_per_month: Faker::Number.between(from: 120, to: 200),
    phone_number: Faker::PhoneNumber.cell_phone,
    custom_fields: { skill_level: %w[Beginner Intermediate Expert].sample },
    business: business
  )
end

# Kreiranje projekata i taskova
3.times do
  planned_start_date = Faker::Date.forward(days: 10)
  planned_end_date = Faker::Date.between(from: planned_start_date, to: planned_start_date + 30)

  project = Project.create!(
    name: Faker::Company.name,
    project_type: %w[Residential Commercial Infrastructure].sample,
    address: Faker::Address.full_address,
    project_manager: Faker::Name.name,
    planned_start_date: planned_start_date,
    planned_end_date: planned_end_date,
    estimated_cost: Faker::Number.decimal(l_digits: 5, r_digits: 2),
    description: Faker::Lorem.paragraph,
    custom_fields: { priority: %w[High Medium Low].sample },
    business: business
  )

  # Kreiranje taskova unutar projekta
  task_ids = []
  3.times do
    task_start_date = Faker::Date.between(from: planned_start_date, to: planned_end_date)
    duration = Faker::Number.between(from: 1, to: 10) # Dužina taska u danima
    task_end_date = task_start_date + duration.days

    task = Task.create!(
      name: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.sentence,
      quantity: Faker::Number.between(from: 1, to: 100),
      unit: %w[kg m3 pcs].sample,
      planned_start_date: task_start_date,
      planned_end_date: task_end_date,
      planned_cost: Faker::Number.decimal(l_digits: 4, r_digits: 2),
      progress: Faker::Number.decimal(l_digits: 1, r_digits: 2), # Random progress između 0.0 i 1.0
      custom_fields: { urgency: %w[Critical Important Normal].sample },
      project: project
    )
    task_ids << task.id
  end

  # Kreiranje veza (links) između taskova
  if task_ids.length > 1
    (0..task_ids.length - 2).each do |i|
      Link.create!(
        source_id: task_ids[i],
        target_id: task_ids[i + 1],
        link_type: "0" # Finish-to-Start veza
      )
    end
  end
end

# Kreiranje aktivnosti za svaki task
Task.all.each do |task|
  # Odaberi nasumično 1-3 materijala za svaki task
  materials = Material.order("RANDOM()").limit(rand(1..3))
  materials.each do |material|
    Activity.create!(
      activity_type: "material",
      start_date: task.planned_start_date,
      end_date: task.planned_end_date,
      task: task,
      activityable: material,
      quantity: rand(1..100) # Nasumična količina između 1 i 100
    )
  end

  # Odaberi nasumično 1-2 mašine za svaki task
  machines = Machine.order("RANDOM()").limit(rand(1..2))
  machines.each do |machine|
    Activity.create!(
      activity_type: "machine",
      start_date: task.planned_start_date,
      end_date: task.planned_end_date,
      task: task,
      activityable: machine,
      quantity: rand(1..10) # Nasumična količina između 1 i 10
    )
  end

  # Odaberi nasumično 1-3 radnika za svaki task
  workers = Worker.order("RANDOM()").limit(rand(1..3))
  workers.each do |worker|
    Activity.create!(
      activity_type: "worker",
      start_date: task.planned_start_date,
      end_date: task.planned_end_date,
      task: task,
      activityable: worker,
      quantity: rand(1..5) # Nasumična količina između 1 i 5
    )
  end
end

puts "Seed podaci uspješno kreirani! 🎉"