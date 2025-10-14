release: rails db:migrate
web: bundle exec puma -C config/puma.rb
assets: npm run build:css && rails assets:precompile
