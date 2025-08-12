require 'business_time'

# Radni tjedan
BusinessTime::Config.work_week = [:mon, :tue, :wed, :thu, :fri]

# Primjeri praznika (možeš dodati iz baze ili gema `holidays`)
#BusinessTime::Config.holidays << Date.parse("2025-01-01")
#BusinessTime::Config.holidays << Date.parse("2025-05-01")
