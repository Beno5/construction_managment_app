# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Construction Management Application** built with Ruby on Rails 7.0.8, Ruby 3.2.2, and PostgreSQL. The application helps manage construction projects, tasks, resources, and includes AI-powered document analysis for importing project data from Excel, Word, and PDF files.

**Tech Stack:**
- Backend: Rails 7.0.8, PostgreSQL
- Frontend: Hotwire (Turbo + Stimulus), Tailwind CSS, Flowbite
- Background Jobs: Sidekiq with Redis
- AI Integration: OpenAI API for document analysis
- File Processing: Roo (Excel), Docx, PDF Reader
- Authentication: Devise
- File Storage: Active Storage with AWS S3

## Communication Guidelines

**Language Policy:**
- The user communicates in **Bosnian/Serbian** (conversations, questions, discussions)
- **ALL code must be in English**: variable names, function names, class names, module names
- **ALL comments must be in English**: inline comments, documentation, code explanations
- **ALL git commits must be in English**: commit messages, branch names, PR descriptions
- User-facing content (views, i18n translations) can be in Serbian/Bosnian as appropriate

**Important:** Even though the user speaks Serbian/Bosnian, maintain English for all code artifacts to ensure international code standards and future maintainability.

## Development Commands

### Starting the Application

**Development (with hot-reloading):**
```bash
bin/dev
```
This runs both the Rails server on port 3000 and Tailwind CSS watcher.

**Production-like (with Sidekiq):**
```bash
bundle exec foreman start -f Procfile
```
This runs the web server and Sidekiq worker.

**Sidekiq Dashboard:**
- Available at: `/sidekiq` (currently no auth required)

### Database

```bash
# Setup database
bundle exec rails db:create db:migrate

# Reset database
bundle exec rails db:drop db:create db:migrate

# Run seeds
bundle exec rails db:seed

# Generate ERD diagram
bundle exec erd
```

### Testing

```bash
# Run all tests
bundle exec rails test

# Run specific test file
bundle exec rails test test/models/project_test.rb

# Run system tests
bundle exec rails test:system
```

### Linting & Code Quality

```bash
# Run RuboCop
bundle exec rubocop

# Auto-fix issues
bundle exec rubocop -a

# Check specific file
bundle exec rubocop app/models/project.rb
```

### Asset Pipeline

```bash
# Compile Tailwind CSS
bundle exec rails tailwindcss:build

# Watch Tailwind (already included in bin/dev)
bundle exec rails tailwindcss:watch

# Precompile assets
bundle exec rails assets:precompile
```

### Background Jobs

```bash
# Run Sidekiq worker
bundle exec sidekiq -C config/sidekiq.yml

# Clear all jobs
bundle exec rails runner "Sidekiq.redis(&:flushdb)"
```

## Architecture & Data Model

### Core Domain Hierarchy

```
User
  └─ Business (multi-tenancy)
      ├─ Projects
      │   ├─ Tasks
      │   │   └─ SubTasks
      │   │       ├─ Activities (planned resources)
      │   │       ├─ RealActivities (actual resources used)
      │   │       ├─ CustomResources
      │   │       ├─ Documents
      │   │       └─ PinnedNorms (many-to-many with Norms)
      │   └─ Documents
      ├─ Norms (predefined resource templates)
      ├─ Workers
      ├─ Machines
      └─ Materials
```

**Key Model Behaviors:**
- `Project`, `SubTask`: Include `CustomFields` concern for JSONB-based dynamic fields
- Hierarchical positioning: Tasks/SubTasks auto-assign positions and reorder on deletion
- Date validations: End dates must be after start dates across Project/Task/SubTask
- Locale support: Serbian (sr) is the default locale, English (en) also available

### Multi-Tenancy Pattern

The app uses **Business** as the tenant boundary:
- `ApplicationController` sets `@current_business` via `session[:current_business_id]`
- Helper method `current_business` available in controllers/views
- Most resources are scoped through `business_id`
- Users can belong to multiple businesses

### AI-Powered Import System

**Flow:**
1. User uploads Excel/Word/PDF via `ProjectsController#import_ai`
2. File is base64-encoded and queued to `AiImportJob` (Sidekiq)
3. `AiExcelAnalyzerService` chunks the document and sends to OpenAI
4. OpenAI extracts structured project/task/subtask data
5. `AiImportBuilderService` creates database records from AI response

**Key Files:**
- `app/jobs/ai_import_job.rb` - Background job orchestration
- `app/services/ai_excel_analyzer_service.rb` - Document chunking + OpenAI integration
- `app/services/ai_import_builder_service.rb` - Database record creation
- `app/controllers/projects_controller.rb:import_ai` - Upload endpoint

### Dynamic Attributes System

`UpdateDynamicAttributesService` recalculates SubTask attributes on save/destroy:
- Triggered via `after_save` and `after_destroy` callbacks
- Updates calculated fields based on related Activities and CustomResources
- Located in `app/services/update_dynamic_attributes_service.rb`

### Frontend Architecture

**Stimulus Controllers** (in `app/javascript/controllers/`):
- `activity_controller.js` - Manages activity forms and calculations
- `custom_resource_controller.js` - Custom resource form interactions
- `gantt_trigger_controller.js` - Gantt chart initialization
- `norms_controller.js` - Norm selection and pinning
- `real_resources_controller.js` - Real activity tracking

**Hotwire Usage:**
- Turbo Frames for partial page updates
- Turbo Streams for real-time updates
- Stimulus for JavaScript sprinkles

**Gantt Chart:**
- Custom implementation with drag-and-drop
- API endpoints in `Api::GanttController`
- Links between tasks stored in `Link` model

## Configuration Notes

### Environment Variables

Required `.env` variables:
```
DATABASE_URL (production only)
OPENAI_API_KEY
OPENAI_MODEL (defaults to gpt-4.1)
AWS_ACCESS_KEY_ID (for Active Storage)
AWS_SECRET_ACCESS_KEY
AWS_REGION
AWS_BUCKET
REDIS_URL (Heroku) or local Redis
```

**Redis Detection:**
The app auto-detects Heroku's `REDIS_URL` or `REDIS_TLS_URL` for Sidekiq configuration.

### Internationalization (i18n)

- Default locale: `:sr` (Serbian)
- Available locales: `:en`, `:sr`
- User-specific locale stored in `users.locale`
- Session-based fallback via `session[:locale]`
- Locale parameter required in all URLs via `default_url_options`

### Active Storage

Configured for AWS S3 in production (`config/storage.yml`). Used for:
- Document attachments on Projects/Tasks/SubTasks
- AI import file uploads

## Common Development Patterns

### Creating New Resources

1. Scope to current business: `@current_business.resources.build`
2. Associate with current user: `resource.user = current_user`
3. Use strong parameters for security
4. Include custom_fields in permits if using CustomFields concern

### Working with SubTasks

SubTasks have complex calculations:
- Auto-position assignment on create
- Reordering on destroy
- Dynamic duration calculation based on start/end dates
- Format: `show_position` returns "#{task.position}.#{subtask.position}"

### Background Job Patterns

Always rescue specific exceptions in jobs:
```ruby
rescue ActiveRecord::RecordInvalid => e
  Rails.logger.error "Record invalid: #{e.record.errors.full_messages}"
rescue StandardError => e
  Rails.logger.error "Error: #{e.message}"
ensure
  # Cleanup temp files
end
```

## Testing Strategy

- Use fixtures in `test/fixtures/` for test data
- System tests use Selenium WebDriver + Capybara
- Test helpers in `test/test_helper.rb`

## Deployment

The app is Heroku-ready:
- `Procfile` defines web + worker dynos
- Database URL via `ENV['DATABASE_URL']`
- Redis auto-configured for Sidekiq
- Assets precompiled during build

## RuboCop Configuration

Key rules (see `.rubocop.yml`):
- Max line length: 120 characters
- Max method length: 15 lines
- Max class length: 200 lines
- Tab width: 2 spaces
- Frozen string literals: disabled
- Excludes: db/schema.rb, config/**, bin/**, node_modules/**, vendor/**, public/**
