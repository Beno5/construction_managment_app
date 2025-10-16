# ⚠️ Brisanje postojećih podataka (oprez u produkciji!)
Activity.destroy_all
Link.destroy_all
SubTask.destroy_all
Task.destroy_all
Project.destroy_all
Material.destroy_all
Machine.destroy_all
Worker.destroy_all
Business.destroy_all
User.destroy_all

puts "🧹 Svi podaci obrisani."

# 👤 Kreiranje korisnika
@beno = User.create!(
  email: "beno@example.com",
  password: "password",
  password_confirmation: "password",
  terms: true
)

@kole_user = User.create!(
  email: "kole@example.com",
  password: "password",
  password_confirmation: "password",
  terms: true
)

puts "👥 Kreirani korisnici:"
puts "- Beno: #{@beno.email}"
puts "- Kole: #{@kole_user.email}"

# 💼 Kreiranje poslovanja
@beno_business = Business.create!(
  name: Faker::Company.name,
  address: Faker::Address.full_address,
  vat_number: Faker::Number.unique.number(digits: 10).to_s,
  registration_number: Faker::Number.unique.number(digits: 8).to_s,
  owner_first_name: Faker::Name.first_name,
  owner_last_name: Faker::Name.last_name,
  custom_fields: { additional_info: Faker::Lorem.sentence },
  user: @beno,
  currency: Business.currencies.keys.sample
)

@kole_business = Business.create!(
  name: Faker::Company.name,
  address: Faker::Address.full_address,
  vat_number: Faker::Number.unique.number(digits: 10).to_s,
  registration_number: Faker::Number.unique.number(digits: 8).to_s,
  owner_first_name: Faker::Name.first_name,
  owner_last_name: Faker::Name.last_name,
  custom_fields: { additional_info: Faker::Lorem.sentence },
  user: @kole_user,
  currency: Business.currencies.keys.sample
)

puts "🏢 Kreirani biznisi:"
puts "- #{@beno_business.name} (vlasnik: #{@beno.email})"
puts "- #{@kole_business.name} (vlasnik: #{@kole_user.email})"

# Kreiranje materijala, mašina i radnika za oba biznisa
[@beno_business, @kole_business].each do |biz|
  user = biz.user

  puts "🏗️ Kreiranje podataka za #{biz.name} (vlasnik: #{user.email})..."

  # 🧱 Materijali
  10.times do
    Material.create!(
      name: Faker::Construction.material,
      price_per_unit: Faker::Number.decimal(l_digits: 2, r_digits: 2),
      unit_of_measure: Material.unit_of_measures.keys.sample, # enum
      description: Faker::Lorem.sentence,
      custom_fields: { supplier: Faker::Company.name },
      user: user,
      business: biz
    )
  end

  # ⚙️ Mašine
  10.times do
    Machine.create!(
      name: Faker::Appliance.equipment,
      description: Faker::Lorem.sentence,
      unit_of_measure: Machine.unit_of_measures.keys.sample,
      price_per_unit: Faker::Number.decimal(l_digits: 2, r_digits: 2),
      fixed_costs: Faker::Number.decimal(l_digits: 3, r_digits: 2),
      custom_fields: { maintenance_schedule: Faker::Lorem.sentence },
      user: user,
      business: biz
    )
  end

  # 👷‍♂️ Radnici
  10.times do
    Worker.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      profession: Faker::Job.title,
      description: Faker::Lorem.sentence,
      unit_of_measure: Worker.unit_of_measures.keys.sample,
      price_per_unit: Faker::Number.decimal(l_digits: 2, r_digits: 2),
      is_team: Faker::Boolean.boolean,
      custom_fields: { skill_level: %w[Beginner Intermediate Expert].sample },
      user: user,
      business: biz
    )
  end

  puts "✅ Kreirano 10 materijala, 10 mašina i 10 radnika za #{biz.name}"
end

# Kreiranje normi za oba biznisa
[@beno_business, @kole_business].each do |biz|
  user = biz.user

  puts "📐 Kreiranje normi za #{biz.name} (vlasnik: #{user.email})..."

  norms_data = [
    {
      name: "Oplata od daske – Ravni temelji",
      description: "Ravni temelji, mašinski fundamenti, oplata 1-strana",
      info: "Stari način građenja",
      norm_type: :worker,
      subtype: :skilled,
      unit_of_measure: "m2",
      norm_value: 0.37,
      tags: ["oplate", "temelji", "daske", "ravni", "stari način"]
    },
    {
      name: "Oplata od daske – Ravni temelji",
      description: "Ravni temelji, mašinski fundamenti, oplata 1-strana",
      info: "Stari način građenja",
      norm_type: :worker,
      subtype: :unskilled,
      unit_of_measure: "m2",
      norm_value: 0.67,
      tags: ["oplate", "temelji", "daske", "ravni", "stari način"]
    },
    {
      name: "Oplata kosih i nagnutih ploča",
      description: "Oplata kosih betonskih ploča",
      info: "Bez obzira na veličinu",
      norm_type: :worker,
      subtype: :skilled,
      unit_of_measure: "m2",
      norm_value: 0.52,
      tags: %w[kosine ploče betonske doka]
    },
    {
      name: "Oplata kosih i nagnutih ploča",
      description: "Oplata kosih betonskih ploča",
      info: "Bez obzira na veličinu",
      norm_type: :worker,
      subtype: :unskilled,
      unit_of_measure: "m2",
      norm_value: 0.78,
      tags: %w[kosine ploče betonske doka]
    },
    {
      name: "Mašinski iskop humusa",
      description: "Buldožer 50ka – 10–20cm",
      info: "Mašinski zemljani radovi",
      norm_type: :machine,
      unit_of_measure: "m2",
      norm_value: 0.0592,
      tags: ["iskop", "humus", "buldožer", "zemljani radovi"]
    },
    {
      name: "Mašinsko rastiranje zemlje II kat",
      description: "Rastiranje slojeva zemlje",
      info: "GAT komponenta",
      norm_type: :machine,
      unit_of_measure: "m3",
      norm_value: 0.065,
      tags: %w[rastiranje zemlja mašina gat]
    },
    {
      name: "Oplata za poklopne ploče dimnjaka",
      description: "1.60/60 2.60/100 3.60/160",
      info: "Daska 24mm + grede",
      norm_type: :worker,
      subtype: :skilled,
      unit_of_measure: "m2",
      norm_value: 0.55,
      tags: %w[dimnjak poklopac oplate daske]
    },
    {
      name: "Oplata za poklopne ploče dimnjaka",
      description: "1.60/60 2.60/100 3.60/160",
      info: "Daska 24mm + grede",
      norm_type: :worker,
      subtype: :unskilled,
      unit_of_measure: "m2",
      norm_value: 0.69,
      tags: %w[dimnjak poklopac oplate daske]
    },
    {
      name: "Dvostruka oplata temeljnih greda",
      description: "Formira se DOKA ploča d=27mm",
      info: "Uključuje distancere i klince",
      norm_type: :worker,
      subtype: :skilled,
      unit_of_measure: "m2",
      norm_value: 0.40,
      tags: %w[doka dvostruka temelj oplate]
    },
    {
      name: "Oplata balkonskih zidova i ploča",
      description: "1. Balkonski ogr. zidovi 2. Ravne ploče",
      info: "Štafla, bunarske motke",
      norm_type: :worker,
      subtype: :unskilled,
      unit_of_measure: "m2",
      norm_value: 0.82,
      tags: %w[balkon zidovi ploče oplate]
    }
  ]

  norms_data.each do |norm_attrs|
    Norm.create!(norm_attrs.merge(business: biz, user: user))
  end

  puts "✅ Kreirano #{norms_data.size} normi za #{biz.name}"
end

puts "🎉 Seed podaci uspješno kreirani!"
