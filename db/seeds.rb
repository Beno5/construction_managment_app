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

# Kreiranje korisnika (npr. admin user)
User.create!(
  email: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  terms: true
)

# Kreiranje korisnika sa poslovanjem
user = User.create!(
  email: "test@example.com",
  password: "password",
  password_confirmation: "password",
  terms: true
)

# Kreiranje poslovanja za korisnika
business = Business.create!(
  name: Faker::Company.name,
  address: Faker::Address.full_address,
  phone_number: Faker::PhoneNumber.phone_number,
  vat_number: Faker::Number.unique.number(digits: 10).to_s,
  registration_number: Faker::Number.unique.number(digits: 8).to_s,
  owner_first_name: Faker::Name.first_name,
  owner_last_name: Faker::Name.last_name,
  custom_fields: { additional_info: Faker::Lorem.sentence },
  user: user,
  currency: Business.currencies.keys.sample
)

# Kreiranje materijala
10.times do
  Material.create!(
    name: Faker::Construction.material,
    price_per_unit: Faker::Number.decimal(l_digits: 2, r_digits: 2),
    unit_of_measure: Material.unit_of_measures.keys.sample, # Koristimo enum
    description: Faker::Lorem.sentence,
    custom_fields: { supplier: Faker::Company.name },
    business: business
  )
end

# Kreiranje mašina
10.times do
  Machine.create!(
    name: Faker::Appliance.equipment,
    description: Faker::Lorem.sentence,
    unit_of_measure: Machine.unit_of_measures.keys.sample, # Nasumična vrijednost iz enuma
    price_per_unit: Faker::Number.decimal(l_digits: 2, r_digits: 2),
    fixed_costs: Faker::Number.decimal(l_digits: 3, r_digits: 2),
    custom_fields: { maintenance_schedule: Faker::Lorem.sentence },
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
    phone_number: Faker::PhoneNumber.cell_phone,
    unit_of_measure: Worker.unit_of_measures.keys.sample, # Koristimo enum
    price_per_unit: Faker::Number.decimal(l_digits: 2, r_digits: 2),
    is_team: Faker::Boolean.boolean,
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
    address: Faker::Address.full_address,
    project_manager: Faker::Name.name,
    planned_start_date: planned_start_date,
    planned_end_date: planned_end_date,
    planned_cost: Faker::Number.decimal(l_digits: 5, r_digits: 2),
    real_cost: Faker::Number.decimal(l_digits: 5, r_digits: 2), # Koristimo real_cost umjesto estimated_cost
    description: Faker::Lorem.paragraph,
    custom_fields: { priority: %w[High Medium Low].sample },
    user: user,
    business: business,
    real_start_date: Faker::Date.between(from: planned_start_date, to: planned_end_date),
    real_end_date: Faker::Date.between(from: planned_start_date, to: planned_end_date + 30)
  )

  # Kreiranje taskova unutar projekta
  task_ids = []
  3.times do
    task_start_date = Faker::Date.between(from: planned_start_date, to: planned_end_date)
    duration = Faker::Number.between(from: 1, to: 10)
    task_end_date = task_start_date + duration.days

    task = Task.create!(
      name: Faker::Lorem.sentence(word_count: 3),
      description: Faker::Lorem.sentence,
      quantity: Faker::Number.between(from: 1, to: 100),
      unit: %w[kg m3 pcs].sample,
      planned_start_date: task_start_date,
      planned_end_date: task_end_date,
      planned_cost: Faker::Number.decimal(l_digits: 4, r_digits: 2),
      progress: Faker::Number.decimal(l_digits: 1, r_digits: 2),
      custom_fields: { urgency: %w[Critical Important Normal].sample },
      project: project
    )
    task_ids << task.id
  end

  # Kreiranje veza (links) između taskova
  next unless task_ids.length > 1

  (0..task_ids.length - 2).each do |i|
    Link.create!(
      source_id: task_ids[i],
      target_id: task_ids[i + 1],
      link_type: "0" # Finish-to-Start veza
    )
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
      quantity: rand(1..100)
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
      quantity: rand(1..10)
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
      quantity: rand(1..5)
    )
  end
end

puts "Seed podaci uspješno kreirani! 🎉"
