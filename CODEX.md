# CODEX

## Project Overview
- Construction management Rails app where users create businesses, then manage projects → tasks → sub tasks with linked resources, costs, and documents.
- Supports planned vs real execution through activities and real activities tied to sub tasks, plus norms (productivity standards) that drive planning calculators.
- Resource catalogs (workers, machines, materials, custom resources) live under each business; documents can attach to projects, tasks, or sub tasks.
- AI import pipeline converts uploaded Excel/Word/PDF files into projects/tasks/sub tasks via OpenAI.
- Tech stack: Ruby 3.2.2, Rails 7.0.8.6, PostgreSQL, Hotwire (Turbo + Stimulus bundled via ESBuild), TailwindCSS, Devise auth, Sidekiq + Redis, Active Storage (local or S3 via Bucketeer), OpenAI SDK, Kaminari pagination, BusinessTime, Flowbite UI components.

## Current Architecture
- **CustomFields concern (CustomFields):** Before save, initializes `custom_fields` hash and strips blank values; helper methods to set/get/remove/list fields.
- **User:** Devise authentication; has many businesses, projects, workers, machines, materials, custom_resources, real_activities, norms. Validates unique email, password length, terms acceptance on create. After initialize sets default locale (`sr`); after commit sends welcome email with `UserMailer`.
- **Business:** Belongs to user (optional in model; FK present); has many projects, workers, machines, materials, norms. Enum `currency` (euro/dolar/dinar). Validates name presence/uniqueness scoped to user. `currency_symbol` helper.
- **Project:** Belongs to business and user; includes CustomFields; has many tasks and documents (delete_all). Enum `status` (pending/active/completed/canceled/paused). Validates name presence/uniqueness per business and end date after start. Methods for earliest start/latest end across tasks.
- **Task:** Belongs to project and user; includes CustomFields; has many sub_tasks and documents (delete_all). Validates name and date order. `before_create` assigns incremental `position`; `after_destroy` reorders siblings. Scope `ordered_by_position` sorts hierarchical positions; `name_with_position` helper.
- **SubTask:** Belongs to task and user; includes CustomFields; has many activities, real_activities, custom_resources, documents (all delete_all); has many sub_task_norms and `pinned_norms` through them. Validates name and date order. `before_create` assigns position; `after_save` and `after_destroy` trigger `UpdateDynamicAttributesService`; `after_destroy` also reorders siblings. Scope `ordered_by_position`; scope `search` on name/description. Enum `unit_of_measure` (m, m2, m3, kg, ton, pieces, liters, roll, bag, set, hours, pauschal). Helpers for duration calc and position display.
- **Activity:** Belongs to sub_task and polymorphic `activityable` (worker/machine/material/custom resource); has many real_activities (destroy). Enum `activity_type` (worker/machine/material/custom). Validates activity_type/quantity/total_cost and polymorphic ids. `after_save`/`after_destroy` cascades updates to parent sub task via service. Ruby-level `search` scans activity fields and linked resource attributes.
- **RealActivity:** Belongs to activity, user, sub_task. Validates quantity numeric ≥ 0. `after_save`/`after_destroy` updates parent sub task via service.
- **Norm:** Belongs to business and user; has many sub_task_norms and sub_tasks. Enums `norm_type` (worker/material/machine) and `subtype` (skilled/unskilled). Scope `for_business`; validates name presence. Optional `auto_calculate` flag influences recalculation.
- **SubTaskNorm:** Join between sub_task and norm.
- **Worker:** Includes CustomFields; belongs to business and user; activityable. Enum `unit_of_measure` (hourly/daily/weekly/monthly/per_task/pauschal). Validates first_name; `name` helper.
- **Machine:** Belongs to business and user; activityable. Enum unit_of_measure matches Worker. Validates name.
- **Material:** Belongs to business and user; activityable. Enum unit_of_measure (kg, m2, m3, pieces, ton, liters, roll, bag, set, pauschal). Validates name.
- **CustomResource:** Belongs to sub_task and user; activityable. Enum `category` (material/worker/machine/custom). Validates quantity/unit_of_measure/price_per_unit/total_cost presence. `name` resolves worker full name when applicable.
- **Document:** Belongs to project/task/sub_task (at least one required). `has_one_attached :file`. Enum `category` (nothing/plan/report/doc_order/offer/other). Custom validation enforces parent assignment.
- **Link:** Dependency between tasks (source/target) with validated presence of ids and link_type.
- **ApplicationRecord search:** Generic `search(query)` scans all columns except timestamps using ILIKE; used across controllers for filtering.

## Controllers & Behavior
- **ApplicationController:** Enforces authentication, locale, current business selection (session-backed), Devise strong params. `after_sign_in_path` directs to businesses index with locale.
- **BusinessesController:** CRUD scoped to current_user; index supports search + pagination with HTML/Turbo Stream; destroy responds with turbo_stream to update lists and clears session business if deleted; `select` switches current business in session.
- **ProjectsController:** Nested under business. Index supports search via Turbo Stream; show paginates tasks and documents. Create/update set current_user and handle validation flash. Destroy responds with turbo_stream. AI actions: `import_ai` (validates ≤20MB, Base64 encodes file, enqueues AiImportJob, caches status), `import_status` (reads cache), `cancel_import` (marks cancellation in cache, attempts Sidekiq cleanup, broadcasts Turbo notification).
- **TasksController:** Nested under project. Show lists sub_tasks and documents with search/pagination; `readonly_mode` flags for form rendering. Create/update redirect to project; destroy recalculates task ordering and renders project show via Turbo (sets no-cache headers) or redirects HTML.
- **SubTasksController:** Nested under task. Show paginates activities, documents, and combined pinned/searched norms; create/update uses strong params, calls `SubTaskPlanningCalculator` on update and can return JSON with recalculated fields; destroy supports Turbo rendering path differences (from project vs task views) and HTML redirect.
- **ActivitiesController:** Creates/updates activities either by updating an existing record or creating new with mapped params; redirects back to sub task show. Destroy removes activity via Turbo Stream (removes row, updates flash) or HTML redirect.
- **RealActivitiesController:** Nested via activity; create/update handle edit vs new based on param, set user/sub_task, compute total_cost from activityable price; redirects to sub task anchor; destroy responds Turbo Stream or HTML redirect.
- **NormsController:** Business-scoped list/search with Turbo Stream; also serves sub task context combining pinned norms and search results. Create/update/destroy standard CRUD; update calls `SubTaskPlanningCalculator` for associated sub tasks when `auto_calculate` true. destroy supports Turbo Stream.
- **WorkersController / MachinesController / MaterialsController:** Business-scoped CRUD with search pagination; responses support Turbo Stream for index and destroy.
- **CustomResourcesController:** For sub task custom resources. If `activity_id` present, updates linked activity/resource; otherwise creates custom_resource (user assigned) and a matching activity. Destroy removes activity via Turbo Stream; redirects on create/update.
- **DocumentsController:** Works for project/task/sub_task parents (auto-detects via params/document). Create handles inline edit vs new using `document_id`; destroy responds Turbo Stream or redirect; uses `has_one_attached :file`.
- **PinnedNormsController:** Adds/removes norms to sub tasks and calls planner; returns JSON with recalculated duration and worker/machine counts plus active norm metadata.
- **API::GanttController:** `data` returns Gantt JSON with prefixed IDs (t_/st_), planned dates, and links; `move_update` updates planned dates/duration for task or sub task based on prefixed id. `normalize_id` prefixes links for Gantt.
- **API::LinksController:** CSRF-null session; create/destroy Link records, normalizing prefixed ids from Gantt.
- **API::TasksController:** CSRF-null session endpoints for create/update/destroy tasks from Gantt; maps incoming fields to Task columns and parses dates.
- **FetchDataController:** JSON endpoints for unit options, business resources by category, resource details, activity/resource info for modals, document metadata, activity checker (including Norm → SubTask usage), and combined activity/real activity info for modal prefill.
- **Devise controllers (Users::Registrations/Sessions/Passwords):** Customized flows for locale-aware redirects, inline error handling, and sign-out behavior.
- **Turbo usage:** Index/destroy actions across businesses/projects/tasks/sub_tasks/resources/norms/materials/machines/documents respond with Turbo Stream templates; ActivitiesController destroy uses Turbo Stream removal; AiImportJob and cancel_import broadcast Turbo notifications and project list replacements; Gantt refresh uses Turbo-triggered Stimulus controller.

## Services, Jobs, Modules
- **UpdateDynamicAttributesService:** Transactional updater that reacts based on record type; for SubTask sums `activities.total_cost`; for Task aggregates sub task planned/real dates and costs; for Project aggregates task planned/real dates and costs; Activity path re-invokes on parent sub task. Uses `update_columns` and recursively propagates to parent (sub_task → task → project).
- **SubTaskPlanningCalculator:** Uses pinned norms and sub task quantity to compute duration and workforce/machines. If no norms or quantity, zeroes fields. Otherwise forward-calculates based on average norms and default hours per day (9), or reverses counts when duration/dates change; updates planned dates from duration or vice versa.
- **AiExcelAnalyzerService:** Parses uploaded Excel/Word/PDF into text chunks (Roo/Docx/PDF::Reader), processes chunks with OpenAI (configurable model via ENV, temperature 0.1), concurrency via Concurrent::Promise with retries/backoff, timeouts, Redis caching, and merges chunk results (logs failures, includes warnings). Provides metrics logging.
- **AiImportBuilderService:** Builds Project/Task/SubTask records from AI JSON, ensuring unique project names and mapping unit strings to SubTask enums.
- **AiImportJob:** Sidekiq-backed job (`queue_as :default`) invoked by ProjectsController import; writes Base64 file to tmp, runs analyzer, builds project, broadcasts Turbo notification and project list refresh, caches/clears import status, handles cancellation flag, and cleans temp file. Error branches send Turbo notifications.
- **Modules/Concerns:** CustomFields only model concern in use.

## Frontend Structure
- **Stimulus controllers:**
  - `activity_controller`: Modal setup for activity forms, toggle read-only modes, fetch resources by category, populate fields, compute totals.
  - `ai_import_status_controller`: Polls import status endpoints, disables/enables import button, shows/hides notification, supports cancel action.
  - `auto_dismiss_controller`: Auto-fades/removes notices after delay.
  - `custom_resource_controller`: Handles resource modal modes (create/edit/show), fetches activity/resource data, populates fields, toggles worker/name inputs, computes total cost.
  - `edit_document_controller`: Validates file presence on create, displays selected filename, loads document data via fetch for edit modal.
  - `gantt_trigger_controller`: Reloads Gantt chart data for a project element then self-removes.
  - `highlight_controller`: Temporary highlight border for new elements.
  - `loading_controller`: Global Turbo event listeners to show/hide loading overlay with request counting.
  - `modal_contoller`: Basic open/close for modal target.
  - `norms_controller`: Handles pinned norm checkbox interactions, disables conflicting norms, updates duration/worker/machine fields via JSON response.
  - `real_resources_controller`: Populates real activity modal fields from fetch, computes totals, sets form action/CSRF.
  - `search_controller`: Debounced form submission for search inputs.
  - `sidebar_controller`: Collapsible sidebar state with localStorage per user.
  - `subtask_controller`: Sends PATCH JSON to recalc sub task planning, updates displayed dates/counts.
  - `toggle_controller`: Collapsible section toggle with persisted state.
  - `track_changes_controller`: Tracks form changes to show save button and warn on unload.
- **Custom JS (app/javascript/custom):** Dark mode toggle, custom confirm dialog, constants, flash message helpers, sidebar behavior, modal helpers, Gantt initialization trigger, etc., bundled via ESBuild and loaded from `app/javascript/application.js`.
- **JavaScript bundling:** ESBuild compiles `app/javascript/application.js` into `app/assets/builds/application.js` (619KB bundle including Turbo, Stimulus, Flowbite, all controllers, and custom modules). All 17 Stimulus controllers are manually registered in `app/javascript/controllers/index.js`. Build runs via `yarn build` (production) or `yarn build --watch` (development).
- **Views/partials:** Shared layout pieces in `app/views/partials` (headers/nav/sidebar, breadcrumbs, cards, tables, turbo notification, custom fields tooltip, loading overlay) and modal partials in `app/views/modals` (custom fields, resources, documents, delete confirmation). Task/sub task views use navbar partials for sections (planned vs real resources, info/communication, resources table). Turbo Stream templates exist for destroy actions across resources.

## File Handling
- **Documents:** `Document` has_one_attached `file`; stored via Active Storage using `local`/`test` disk or S3 (`bucketeer` config using BUCKETEER_* env vars). Controllers auto-detect parent (project/task/sub task) and enforce category + name; destroy uses Turbo Stream to update views.
- **AI import workflow:** ProjectsController `import_ai` Base64-encodes uploaded file (max 20MB) and enqueues `AiImportJob`. Job writes temp file under `tmp/`, AiExcelAnalyzerService processes file content with OpenAI, AiImportBuilderService creates records, Turbo notifications/lists refreshed, temp file removed. Import status/cancellation tracked via Rails.cache and Sidekiq job IDs.

## Data Flows
- **Hierarchies:** Business → Project → Task → SubTask → Activities → RealActivities/CustomResources; SubTask also links to Norms via SubTaskNorm and Documents can attach at any level.
- **Recalculation chain:** Activity and RealActivity `after_save/after_destroy` invoke `UpdateDynamicAttributesService` on their sub task; SubTask `after_save/after_destroy` also triggers service. Service aggregates totals and dates upward to Task then Project using `update_columns`, recursing to parents. Task/SubTask `before_create` set positions; `after_destroy` reorder siblings.
- **Planning propagation:** `PinnedNormsController` updates pinned norms and calls `SubTaskPlanningCalculator` which adjusts duration, worker/machine counts, and planned dates based on norms/quantity or date/duration changes. Norm updates with `auto_calculate` flag also trigger recalculation across linked sub tasks.
- **Gantt API flow:** API::GanttController builds JSON from tasks/sub tasks (with prefixed IDs) and Links; move_update updates planned dates/duration for tasks/sub tasks.

## Performance-Sensitive Areas
- `UpdateDynamicAttributesService` runs inside transactions and uses `update_columns` recursively on activity/sub_task/task/project changes; frequent callbacks on save/destroy may cascade multiple queries across hierarchy.
- `Activity.search` loads activityable associations and performs Ruby-level filtering, which can be costly with large datasets.
- AI import path (AiExcelAnalyzerService + OpenAI calls + AiImportJob) processes potentially large files with chunking, caching, retries, and network calls; job includes multiple fetch/render steps and Sidekiq interactions.
- `SubTaskPlanningCalculator` runs on sub task updates and norm changes, performing multiple calculations and attribute updates including date adjustments.

## Developer Reference
- **Setup:** `bin/setup` installs gems, runs `bundle check`/`bundle install`, `bin/rails db:prepare`, clears logs/tmp, restarts app. App uses Procfile: `web` (puma via config/puma.rb) and `worker` (sidekiq with config/sidekiq.yml). Dev env: `Procfile.dev` runs three processes: `bin/rails server -p 3000`, `yarn build --watch` (ESBuild JavaScript watcher), and `bin/rails tailwindcss:watch` (Tailwind CSS watcher). Yarn/Node deps tracked in package.json; uses `jsbundling-rails` gem.
- **JavaScript building:** ESBuild bundles `app/javascript/application.js` → `app/assets/builds/application.js`. Build scripts: `yarn build` (one-time production build), `yarn build --watch` (development watch mode). All Stimulus controllers manually registered in `app/javascript/controllers/index.js`. Production deployments (Heroku) require both Node.js and Ruby buildpacks (Node.js must run first to build assets before Rails precompilation).
- **Environment variables:** `OPENAI_API_KEY` (optional `OPENAI_MODEL`), `REDIS_URL`/`REDISCLOUD_URL` (Redis connection + Sidekiq + Rails.cache), `BUCKETEER_AWS_ACCESS_KEY_ID`, `BUCKETEER_AWS_SECRET_ACCESS_KEY`, `BUCKETEER_AWS_REGION`, `BUCKETEER_BUCKET_NAME` for S3 storage. Devise uses standard credentials; BusinessTime/weekdays configured in initializer.
- **Background jobs:** Run Sidekiq with `bundle exec sidekiq -C config/sidekiq.yml` (queue `default`, concurrency 5). Sidekiq Web mounted at `/sidekiq` (no auth in routes). AiImportJob enqueued via ProjectsController import.
- **Imports:** Trigger AI import through POST `business/:business_id/projects/import_ai` with file param; status via `import_status`, cancellation via `cancel_import` (affects Sidekiq sets and cache flags).
- **Assets/frontend:** Stimulus controllers manually registered in `app/javascript/controllers/index.js` and bundled via ESBuild. Tailwind config in `config/tailwind.config.js`. Flowbite (2.5.2) bundled as npm package. Built assets output to `app/assets/builds/` (gitignored, rebuilt on deploy). Layout uses `javascript_include_tag "application"` instead of importmap tags.
