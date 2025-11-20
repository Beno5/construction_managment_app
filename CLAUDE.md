# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Construction Management Application** built with Ruby on Rails 7.0.8, Ruby 3.2.2, and PostgreSQL. The application helps manage construction projects, tasks, resources, and includes AI-powered document analysis for importing project data from Excel, Word, and PDF files.

**Tech Stack:**
- Backend: Rails 7.0.8, PostgreSQL
- Frontend: Hotwire (Turbo + Stimulus), Tailwind CSS, Flowbite
- JavaScript Bundler: ESBuild (via jsbundling-rails)
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

### Asset Pipeline & JavaScript Building

```bash
# Build JavaScript with ESBuild (one-time)
yarn build

# Watch JavaScript for changes (auto-rebuild)
yarn build --watch

# Compile Tailwind CSS
bundle exec rails tailwindcss:build

# Watch Tailwind (already included in bin/dev)
bundle exec rails tailwindcss:watch

# Precompile all assets for production
bundle exec rails assets:precompile

# Clean compiled assets
bundle exec rails assets:clobber
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

**Performance Optimization - Cascade Deletion:**
All associations in the Project → Task → SubTask hierarchy use `dependent: :delete_all`:
- **Project**: `has_many :tasks, dependent: :delete_all`
- **Task**: `has_many :sub_tasks, dependent: :delete_all`
- **SubTask**: `has_many :activities, :real_activities, :custom_resources, :documents, :sub_task_norms, dependent: :delete_all`

**Important distinction:**
- When deleting a **Project**: Uses SQL DELETE (no callbacks, extremely fast)
- When deleting individual **Task/SubTask**: Callbacks still run normally (`after_destroy`, `reorder_tasks`, `UpdateDynamicAttributesService`)
- This optimization only affects cascade deletion through parent records
- Business logic (positioning, reordering, dynamic attributes) remains intact for manual deletions

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
- `sidebar_controller.js` - Collapsible sidebar with slim/expanded modes
- `toggle_controller.js` - Collapsible sections with localStorage persistence
- `auto_dismiss_controller.js` - Auto-dismisses notifications after timeout
- `loading_controller.js` - Global loading overlay management

**Hotwire Usage:**
- Turbo Frames for partial page updates
- Turbo Streams for real-time updates
- Stimulus for JavaScript sprinkles

**Gantt Chart:**
- Custom implementation with drag-and-drop
- API endpoints in `Api::GanttController`
- Links between tasks stored in `Link` model

**UI Components:**
- Collapsible sidebar with toggle button (desktop only)
  - Expands to show icons + labels (256px wide)
  - Collapses to show icons only (80px wide)
  - User preference saved in localStorage per user
- Collapsible sections with toggle switches
  - Used throughout the app for expandable content areas
  - State persisted in localStorage per user and section ID
  - Examples: project tasks table, norms table, form sections

## JavaScript Bundling with ESBuild

**Migration from Importmap to ESBuild:**
The app was migrated from `importmap-rails` to `jsbundling-rails` with ESBuild for better performance, tree-shaking, and modern module bundling.

**Current Setup:**
- **Bundler**: ESBuild (via `jsbundling-rails` gem)
- **Entry Point**: `app/javascript/application.js`
- **Output**: `app/assets/builds/application.js` (619 KB bundle + 953 KB source maps)
- **Dependencies**: Turbo (8.0.12), Stimulus (3.2.2), Flowbite (2.5.2)
- **Build Scripts** (in `package.json`):
  - `yarn build` - Production build (one-time)
  - `yarn build --watch` - Development watch mode (auto-rebuild on changes)
  - `yarn build:css` - Tailwind CSS build

**Stimulus Controllers:**
All 17 controllers are **manually registered** in `app/javascript/controllers/index.js`:
```javascript
import { application } from "./application"
import ActivityController from "./activity_controller"
// ... all other controllers

application.register("activity", ActivityController)
application.register("sidebar", SidebarController)
// ... etc
```

**Development Workflow:**
```bash
# Start all development processes
bin/dev

# This runs (via Procfile.dev):
# - Rails server on port 3000
# - ESBuild watcher (yarn build --watch)
# - Tailwind CSS watcher (rails tailwindcss:watch)
```

**Production Build:**
```bash
# Manual build (optional - Heroku does this automatically)
yarn build
bundle exec rails tailwindcss:build
bundle exec rails assets:precompile
```

**Heroku Deployment:**
- **Buildpacks Required** (in this order):
  1. `heroku/nodejs` (runs `yarn install` and `yarn build`)
  2. `heroku/ruby` (runs `bundle install` and `rails assets:precompile`)
- Node.js buildpack **must run first** to build JavaScript before Rails asset precompilation
- ESBuild automatically runs during `rails assets:precompile` via jsbundling-rails

**Key Files:**
- `Gemfile` - Contains `gem "jsbundling-rails"`
- `package.json` - ESBuild build scripts and npm dependencies
- `app/javascript/application.js` - Main entry point
- `app/javascript/controllers/index.js` - Controller registration
- `app/assets/builds/` - Output directory (gitignored)
- `Procfile.dev` - Development process orchestration

**FOUC (Flash of Unstyled Content) Prevention Pattern:**
The app uses a multi-layered approach to prevent visual flashing on page load:

1. **Sidebar FOUC Prevention:**
   - Inline script in `_sidebar.html.erb` runs synchronously before sidebar renders
   - Checks localStorage and adds `sidebar-collapsed` class to `<html>` element
   - CSS applies width/margin changes instantly based on this class
   - No JavaScript manipulation needed - pure CSS-driven state

2. **Toggle Sections FOUC Prevention:**
   - Inline script in `application.html.erb` runs at start of `<body>`
   - Uses MutationObserver to detect toggle sections as they're added to DOM
   - Applies localStorage state and adds `toggle-collapsed` class immediately
   - CSS hides sections with `visibility: hidden` until `toggle-init` class is added
   - Stimulus controller only ensures fallback state sync

**Pattern Benefits:**
- Zero visual flash on page load or refresh
- Works with Turbo navigation (`turbo:load`, `turbo:render` events)
- User preferences persist across sessions
- CSS-driven (faster than JavaScript DOM manipulation)

**Key Files:**
- `app/views/partials/_sidebar.html.erb` - Sidebar inline script
- `app/views/layouts/application.html.erb` - Toggle sections inline script + MutationObserver
- `app/assets/stylesheets/application.tailwind.css` - CSS rules for collapsed states
- `app/javascript/controllers/sidebar_controller.js` - Sidebar toggle logic
- `app/javascript/controllers/toggle_controller.js` - Toggle sections logic

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

### LocalStorage Persistence Pattern

User preferences are stored in localStorage with user-specific keys:
- **Sidebar state**: `sidebar_collapsed_{user_id}` (boolean)
- **Toggle sections**: `toggle_{user_id}_{section_id}` (boolean)

**When implementing new collapsible features:**
1. Add `data-user-id="<%= current_user.id %>"` to the controller element
2. Add `data-section-id="unique-section-name"` for toggle sections
3. Store state as string: `localStorage.setItem(key, value.toString())`
4. Read state: `localStorage.getItem(key) === 'true'`
5. Use inline script for FOUC prevention (see pattern above)
6. Apply CSS-based visibility/state changes for instant feedback

### Preventing FOUC in New Features

When adding collapsible/toggleable UI elements:
1. **Add inline script** before the element renders (in partial or layout)
2. **Check localStorage** synchronously and apply CSS class
3. **Use CSS** for visual state (not JavaScript DOM manipulation)
4. **Stimulus controller** only handles toggle events and state sync
5. **Mark as initialized** with a CSS class (e.g., `toggle-init`, `sidebar-collapsed`)

Example pattern:
```erb
<script>
  (function() {
    const state = localStorage.getItem('feature_state_<%= current_user.id %>');
    if (state === 'collapsed') {
      document.documentElement.classList.add('feature-collapsed');
    }
  })();
</script>
```

## Testing Strategy

- Use fixtures in `test/fixtures/` for test data
- System tests use Selenium WebDriver + Capybara
- Test helpers in `test/test_helper.rb`

## Deployment

The app is Heroku-ready with ESBuild:
- `Procfile` defines web + worker dynos
- Database URL via `ENV['DATABASE_URL']`
- Redis auto-configured for Sidekiq
- **Buildpacks required** (in order):
  1. `heroku/nodejs` - Installs Node.js, runs `yarn install`, runs `yarn build`
  2. `heroku/ruby` - Installs Ruby gems, runs `rails assets:precompile`
- Assets precompiled during build (JavaScript built first, then Rails assets)
- JavaScript bundle (~619 KB) created at `app/assets/builds/application.js`

**First-time Heroku setup:**
```bash
# Add buildpacks in correct order
heroku buildpacks:add heroku/nodejs -a your-app-name
heroku buildpacks:add heroku/ruby -a your-app-name

# Verify order
heroku buildpacks -a your-app-name
# Should show: 1. nodejs  2. ruby
```

## Production Configuration (Heroku)

### Redis Setup

**Redis Cloud Add-on (Free Tier):**
```bash
# Add Redis Cloud addon to Heroku app
heroku addons:create rediscloud:30

# This creates REDISCLOUD_URL environment variable
# Configure REDIS_URL to point to it
heroku config:set REDIS_URL=$(heroku config:get REDISCLOUD_URL)
```

**What it's used for:**
- Sidekiq background job queue
- ActionCable adapter for WebSocket connections
- Rails cache store (optional)

**Configuration Files:**
- `config/cable.yml` - ActionCable uses `REDIS_URL` in production
- Sidekiq auto-detects `REDIS_URL` or `REDIS_TLS_URL`

### ActionCable & Real-Time Features

**Turbo Stream Notifications:**
The app uses ActionCable + Turbo Streams for real-time notifications:
- AI import completion notifications sent to users via `Turbo::StreamsChannel.broadcast_append_to`
- Users subscribe to personal notification channels: `notifications_#{user.id}`
- Subscription managed in `app/views/layouts/application.html.erb` via `turbo_stream_from`

**How it works:**
1. Background job completes (e.g., `AiImportJob`)
2. Job broadcasts Turbo Stream to user's channel
3. ActionCable delivers stream to connected browser
4. Turbo automatically updates DOM with notification
5. Stimulus controller (`auto_dismiss_controller.js`) auto-dismisses after 5 seconds

**WebSocket Connections:**
- Heroku automatically routes WebSocket connections to Rails app
- No special configuration needed - works out-of-the-box
- Connection URL: `wss://your-app.herokuapp.com/cable`
- ActionCable handles WebSocket protocol negotiation

**Production Configuration:**
```ruby
# config/cable.yml (already configured)
production:
  adapter: redis
  url: <%= ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" } %>
  channel_prefix: construction_managment_app_production
```

**Key Files:**
- `app/jobs/ai_import_job.rb` - Broadcasts notifications after AI import
- `app/javascript/controllers/auto_dismiss_controller.js` - Auto-dismisses notifications
- `app/views/layouts/application.html.erb` - Subscribes users to notification streams
- `app/views/partials/_turbo_notification.html.erb` - Notification template

**Real-Time Features (Production-Ready):**
- ✅ AI import completion notifications
- ✅ Auto-refresh of project lists (planned)
- ✅ Flash messages with auto-dismiss
- ✅ WebSocket fallback to long-polling (automatic)

**Testing WebSockets in Production:**
```bash
# Check ActionCable connection in browser console
# Look for: [ActionCable] Connected to wss://...
# Or in Rails logs:
heroku logs --tail --dyno=web | grep ActionCable
```

**Note:** Real-time features work immediately after deploying to Heroku with Redis Cloud addon. No additional configuration required.

## RuboCop Configuration

Key rules (see `.rubocop.yml`):
- Max line length: 120 characters
- Max method length: 15 lines
- Max class length: 200 lines
- Tab width: 2 spaces
- Frozen string literals: disabled
- Excludes: db/schema.rb, config/**, bin/**, node_modules/**, vendor/**, public/**

## Migration History

### ESBuild Migration (November 2025)

**What changed:**
- **Removed**: `importmap-rails` gem
- **Added**: `jsbundling-rails` gem
- **JavaScript Bundler**: Migrated from Importmap to ESBuild
- **Stimulus Controllers**: Changed from auto-loading to manual registration
- **Layout**: Changed from `javascript_importmap_tags` to `javascript_include_tag`

**Files modified:**
- `Gemfile` - Replaced importmap with jsbundling
- `package.json` - Added ESBuild, Turbo, Stimulus, Flowbite as npm packages
- `app/javascript/application.js` - Updated imports to use relative paths
- `app/javascript/controllers/index.js` - Manual controller registration
- `app/views/layouts/application.html.erb` - Updated JavaScript inclusion
- `Procfile.dev` - Added `yarn build --watch` process
- Deleted: `config/importmap.rb`, `bin/importmap`

**Why:**
- Better performance (ESBuild is 10-100x faster than alternatives)
- Tree-shaking (removes unused code)
- Modern module bundling
- Better npm package compatibility
- Source maps for debugging
- Smaller bundle sizes with optimization

**Impact:**
- No breaking changes to functionality
- All 17 Stimulus controllers work identically
- Turbo and Flowbite work as before
- Development workflow improved with faster rebuilds
- Production builds optimized for Heroku
