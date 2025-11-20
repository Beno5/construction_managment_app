Inline Editing & Snapshot System - Requirements Document
Version: 1.0
Date: 2025-01-20
Status: Ready for Implementation

1. System Overview
Purpose
Enable users to edit records directly in tables/forms without page navigation, with ability to restore to previous versions.
Scope

Design: Generic system that works for ALL models in application
Initial Implementation: Start with Workers model as proof-of-concept
Rollout: Then apply to Tasks, SubTasks, Machines, Materials, Projects, and any other models
Views: Index pages (tables) and Show pages (forms)


2. Snapshot System
2.1 Daily Snapshots
When Created:

Every night at 22:00 via scheduled job (Whenever/Sidekiq-Cron/Solid Queue)

What It Does:

For each business:

Delete ALL old daily snapshots
Create NEW daily snapshots for ALL records (all models with Snapshotable)
Delete ALL page_load snapshots



Result:

Always exactly 1 daily snapshot per record (yesterday's 22:00 state)
Zero page_load snapshots remain

Purpose:

Provides "Restore to Yesterday" option


2.2 Page Load Snapshots
When Created:

In controller actions (index, show) when page loads
Before rendering view, after fetching records

What Gets Snapshotted:

Index pages: All visible records on current page (e.g., 10 workers per page)
Show pages: The single record being displayed
Nested views: All visible nested records (e.g., Project show: 10 tasks + 50 subtasks = 60 snapshots)

Multiple Visits:

If user opens page 10 times → creates 10 page_load snapshots
When restoring: use LATEST page_load snapshot (most recent)
All cleaned up at 22:00

Purpose:

Provides "Restore to Page Load" option (beginning of editing session)


2.3 Snapshot Storage
Database Table:
snapshots:
  - model_type (string) - "Worker", "Task", etc.
  - model_id (bigint) - ID of record
  - snapshot_type (string) - "daily" or "page_load"
  - snapshot_data (jsonb) - JSON hash of attributes
  - user_id (references users)
  - business_id (references businesses)
  - created_at, updated_at
Indexes:

[model_type, model_id, snapshot_type]
[business_id, snapshot_type, created_at]
[user_id, snapshot_type, created_at]

What to Store:

Store only attributes as JSON (NOT full model copies)
Include: all editable fields
Exclude: id, created_at, updated_at, internal system fields

Example:
json{
  "name": "Felix Gerhold",
  "hourly_rate": 14.23,
  "profession": "farming_analyst",
  "email": "felix@example.com"
}

2.4 Snapshotable Concern
Include in all models:
rubyclass Worker < ApplicationRecord
  include Snapshotable
end
Methods to provide:

create_snapshot(type:, user:) - Creates snapshot
restore_from_snapshot(snapshot) - Restores entire record
restore_field_from_snapshot(field_name, snapshot) - Restores single field
latest_page_load_snapshot - Gets most recent page_load snapshot
daily_snapshot - Gets daily snapshot
snapshotable_attributes - Returns hash of attributes to snapshot (can be overridden)


3. Inline Editing System
3.1 Activation
How:

User double-clicks any editable field
Field enters edit mode (shows input/select/date picker)
Current value pre-filled and selected
Blue border indicates edit mode

3.2 Field Types
Must support:

Text: Single-line and multi-line
Number: HTML type="number" with step="0.01"
Date: HTML type="date" (browser picker)
Select/Enum: Dropdown with options from model enums
Email: HTML type="email"

3.3 Submission
Three ways to save:

Press Enter key
Click outside field (blur)
For selects: change selection (immediate)

Cancel:

Press ESC key → reverts to original value

NO explicit Save/Cancel buttons (keep UI clean)

3.4 Validation
Client-Side (Minimal):

Required fields: check if empty on blur
Number/Email/Date: HTML input types handle validation
Show error message below field if invalid
Keep field in edit mode until valid

Backend (Authoritative):

Use existing model validations ONLY (don't invent new ones)
If validation fails: return 422 with model.errors.full_messages
If optimistic locking fails: return 409 Conflict


3.5 Response Handling
Success (200):
json{
  "success": true,
  "data": { "id": 123, "name": "Felix Gerhold" }
}

Update display value
Flash green border (1-2 seconds)
Show success toast: "Saved successfully"
Exit edit mode

Validation Error (422):
json{
  "success": false,
  "errors": ["Name is too short (minimum is 2 characters)"]
}

Show red border
Display error below field
Keep in edit mode
Show error toast

Conflict (409):
json{
  "success": false,
  "conflict": true,
  "error": "Record modified by another user"
}

Show alert: "This record was modified by another user. Please refresh the page."
Options: [Refresh Page] [Cancel]


3.6 Loading Indicators
Page Load Snapshots:

Existing loading_controller.js handles this automatically via Turbo events
Shows overlay if snapshot creation takes >200ms

Inline Edit Save:

Only show loading if request takes >500ms
Most saves are instant (<200ms), no indicator needed
If shown: small spinner, disable input


3.7 Stimulus Controller
Name: inline_edit_controller.js
Values:

model - "worker", "task"
field - "name", "hourly_rate"
type - "text", "number", "date", "select"
url - Update endpoint
original - Original value (for cancel)
loadedAt - Page load timestamp (for optimistic locking)
options - For selects: {"farming_analyst": "Farming Analyst"}

Behavior:

Create input elements dynamically based on type
Handle double-click activation
Handle Enter/ESC/blur events
Send PATCH request with JSON
Handle success/error/conflict responses
Update UI accordingly


4. Restore Functionality
4.1 Two Restore Types
Bulk Restore (Entire Record):

Restores ALL fields at once
Available in: Show page (top dropdown) + Index page (row ⋮ menu)

Field-Level Restore (Single Attribute):

Restores only ONE field
Available in: Show page (button next to each field) + Index page (when field in edit mode)


4.2 Two Restore Targets
"Restore to Page Load":

Uses latest page_load snapshot
Restores to state when user opened page

"Restore to Yesterday":

Uses daily snapshot
Restores to yesterday's 22:00 state


4.3 UI Locations
Show Page - Bulk Restore:

Top-right corner near page title
Button: "↶ Restore" with dropdown
Options:

"Restore All Fields to Page Load"
"Restore All Fields to Yesterday"



Show Page - Field Restore:

Right side of each editable field
Small button: [↶ ▾]
Dropdown:

"Restore this field to Page Load"
"Restore this field to Yesterday"



Index Page - Row Restore:

In existing three-dot (⋮) menu
Add below divider:

"↶ Restore Row to Page Load"
"↶ Restore Row to Yesterday"



Index Page - Field Restore:

Appears when field is in edit mode (double-clicked)
Small button next to input: [↶ ▾]
Same dropdown as show page


4.4 Restore Actions
Routes:
rubyresources :workers do
  member do
    patch :restore          # Bulk restore
    patch :restore_field    # Field-level restore
  end
end
Controller Logic:

Find record
Determine snapshot (page_load or daily)
Fetch snapshot from database
If not found: return 404 error
Update record from snapshot JSON
Return success or error

Response:

JSON for field restore: { success: true, field: "name", value: "Felix" }
Turbo Stream or redirect for bulk restore


5. Concurrent Editing (Optimistic Locking)
5.1 How It Works
On Page Load:

Store timestamp: loaded_at = Time.current
Pass to Stimulus via data attribute

On Save:

Send loaded_at with PATCH request
Backend compares with record.updated_at
If updated_at > loaded_at: someone else edited → return 409 Conflict

User Experience:

User sees alert: "Record modified by another user"
Must refresh page to see latest version
User loses their unsaved edit (intentional, prevents overwriting)


5.2 Implementation
Frontend:
html<span data-inline-edit-loaded-at-value="<%= Time.current.iso8601 %>">
Backend:
rubydef update
  loaded_at = params[:loaded_at]&.to_datetime
  
  if loaded_at && @worker.updated_at > loaded_at
    render json: { success: false, conflict: true }, status: 409
    return
  end
  
  # Proceed with update...
end

6. User Interface
6.1 Visual States
Display Mode:

Normal text with hover effect (light gray background)
Cursor: pointer
Border: transparent

Edit Mode:

Blue border (2px solid)
Input focused and text selected
Restore button appears (if configured)

Success:

Green border flash (1-2 seconds)
Return to display mode
Show toast notification

Error:

Red border (stays until fixed)
Error message below field (red text)
Stay in edit mode


6.2 Notifications
Success Toast:

Green background, white text
Message: "Saved successfully"
Duration: 2-3 seconds, auto-dismiss
Position: top-right corner

Error Toast:

Red background, white text
Message: Exact error from backend
Duration: Until dismissed
X button to close

Conflict Alert/Modal:

Yellow/warning style
Message: "Record modified by another user. Please refresh."
Buttons: [Cancel] [Refresh Page]


6.3 Mobile Support

Double-tap to activate (not double-click)
Touch-friendly button sizes (min 44x44px)
Correct input types for mobile keyboards
Test on actual devices


7. Implementation Steps
Step 1: Database & Models

Create snapshots table migration
Create Snapshot model (associations, validations, scopes)
Create Snapshotable concern (create_snapshot, restore methods)
Include Snapshotable in Worker model

Step 2: Nightly Job

Create DailySnapshotJob (delete old, create new, cleanup)
Set up scheduling (Whenever/Sidekiq-Cron/Solid Queue)
Test manually

Step 3: Page Load Snapshots

Create SnapshotableController concern
Add snapshot creation in WorkersController (index, show)
Test with existing loading indicator

Step 4: Inline Edit Stimulus Controller

Create inline_edit_controller.js
Handle all field types (text, number, date, select, email)
Implement save/cancel/validation logic
Handle success/error/conflict responses
Add visual feedback (green flash, red border)

Step 5: Apply to Workers

Update Workers index table (add inline edit data attributes)
Update Workers show form (add inline edit data attributes)
Update WorkersController#update (JSON responses, optimistic locking)
Test all fields thoroughly

Step 6: Restore - Backend

Create RestorableController concern
Add restore and restore_field actions
Add routes for restore actions
Test with curl/Postman

Step 7: Restore - UI (Bulk)

Add bulk restore dropdown to Workers show page (top-level)
Add restore options to Workers index dropdown (⋮ menu)
Wire up to controller actions
Test restoring to page_load and daily

Step 8: Restore - UI (Field-Level)

Add field restore buttons to Workers show page (per field)
Enhance inline_edit_controller.js to show restore in edit mode
Test restoring individual fields

Step 9: Expand to Other Models

Apply to Tasks (in Projects show page)
Apply to SubTasks (in Projects show page)
Apply to Machines (index and show)
Apply to Materials (index and show)
Apply to any other models as needed

Step 10: Polish & Testing

Handle network errors
Mobile responsive testing
Edge cases (conflict resolution, snapshot not found)
Loading states
Comprehensive QA


8. Key Design Decisions
What We Decided
✅ Generic system - works for all models, not just Workers
✅ Start with Workers - proof of concept, then expand
✅ JSON attributes - store only attributes, not full model copies
✅ Two snapshot types - daily (22:00) + page_load (session)
✅ Two restore options - bulk (entire record) + field-level (single attribute)
✅ Optimistic locking - detect conflicts, warn user
✅ Minimal client validation - backend is source of truth
✅ No explicit Save buttons - Enter/blur/ESC instead
✅ Existing loading indicator - use loading_controller.js
✅ One daily snapshot - delete old, create new (no accumulation)
✅ Multiple page_load snapshots OK - use latest, clean up nightly

9. Version 1 vs Version 2
V1 Scope (Implement Now)

Inline editing all field types
Daily and page_load snapshots
Bulk and field-level restore
Optimistic locking
Success/error notifications
Works on Workers first, then all models

V2 Features (Future)

Restore confirmation dialogs
Per-user snapshots
Multiple daily snapshots (hourly)
Field-level locking (Redis)
Visual changed field indicators
Undo/Redo stack (Ctrl+Z)
Snapshot history viewer
Audit trail
Bulk inline editing
Advanced keyboard navigation


10. Important Notes for Claude Code
When Reading This Document

Follow existing code patterns in the codebase
Use existing gems/libraries where possible (don't add unnecessary dependencies)
Adapt to actual model structure (this doc uses Workers as example)
Check existing validations on models (don't invent new ones)
Use existing loading indicator (loading_controller.js via Turbo)
If you see a better way that fits the codebase, suggest it

Things to Check in Codebase

How are controllers structured? (concerns already used?)
How is Stimulus set up? (importmap vs webpack?)
What's the pagination gem? (Kaminari, Pagy, will_paginate?)
Is Turbo being used? (for Turbo Streams)
What's the scheduling setup? (Whenever, Sidekiq, cron?)
Are there existing notification/toast systems?

What NOT to Do

Don't create new validations (use existing model validations)
Don't add complex features from V2 list
Don't optimize prematurely (keep it simple first)
Don't break existing functionality
Don't ignore existing patterns


11. Success Criteria
System is successful when:

Workers model fully functional (inline edit + snapshots + restore)
Easy to apply to other models (just include concern + add data attributes)
Users can edit fields quickly without page navigation
Users can restore mistakes (field-level or bulk)
Concurrent editing conflicts detected and handled
Performance acceptable (<200ms saves, <500ms page loads)
No data loss or corruption
Code follows project conventions


End of Requirements Document




Answer from claude

● Perfect! I've read the requirements document. This is a comprehensive and well-structured specification. Let me provide my analysis:

  1. ✅ Confirmation - I Understand the Requirements

  This is a generic inline editing + snapshot/restore system with:
  - Two snapshot types: Daily (22:00 cleanup/recreate) + Page Load (session-based)
  - Two restore modes: Bulk (entire record) + Field-level (single attribute)
  - Inline editing: Double-click activation, Enter/ESC/blur save/cancel
  - Optimistic locking: Conflict detection via loaded_at vs updated_at
  - Rollout strategy: Workers first (POC), then expand to all models

  2. 📋 Implementation Breakdown

  I suggest 8 logical phases (can be tackled in separate prompts):

  Phase 1: Foundation (Database & Models)

  - Create snapshots table migration
  - Create Snapshot model with associations/scopes
  - Create Snapshotable concern
  - Include in Worker model

  Phase 2: Snapshot Jobs & Controller Integration

  - Create DailySnapshotJob (Sidekiq scheduled job)
  - Create SnapshotableController concern
  - Integrate page load snapshots into WorkersController#index and #show
  - Set up job scheduling (need to clarify which system)

  Phase 3: Inline Edit Stimulus Controller

  - Create inline_edit_controller.js
  - Handle all field types (text, number, date, select, email)
  - Implement save/cancel/validation logic
  - Visual feedback (borders, loading states)

  Phase 4: Workers Backend (JSON API)

  - Update WorkersController#update for JSON responses
  - Add optimistic locking check
  - Handle validation errors properly

  Phase 5: Workers Frontend (View Integration)

  - Add data attributes to Workers index table
  - Add data attributes to Workers show form
  - Wire up inline_edit_controller

  Phase 6: Restore Backend

  - Create RestorableController concern
  - Add restore and restore_field actions
  - Add routes

  Phase 7: Restore UI

  - Bulk restore dropdowns (show page + index ⋮ menu)
  - Field-level restore buttons (show page + edit mode)

  Phase 8: Expand to Other Models

  - Apply to Tasks, SubTasks, Machines, Materials, Projects
  - (This could be batched or done per-model)

  3. 📊 Estimated Prompts Needed

  Conservative estimate: 10-12 prompts
  - Phases 1-7: ~8-10 prompts (some phases may need 2 prompts if complex)
  - Phase 8: 1-2 prompts (if we do it efficiently)
  - Testing/fixes: 1-2 prompts

  Optimistic estimate: 8-9 prompts if everything goes smoothly.

  4. ⚠️ Potential Codebase Issues to Check

  Before we start, I need to verify:

  1. Scheduling System: Which job scheduler is configured?
    - Whenever gem? Sidekiq-Cron? Solid Queue? Heroku Scheduler?
  2. Stimulus Setup: How are Stimulus controllers imported?
    - Importmap? Webpack? esbuild?
  3. Pagination: Which gem is used?
    - Affects how we snapshot "visible records" on index pages
  4. Existing Concerns: Are controller/model concerns already in use?
    - Need to follow existing patterns
  5. Toast/Notification System: Does one exist?
    - Or should I create a simple one with Stimulus?
  6. Turbo Streams: Currently used for real-time updates
    - Should we use Turbo Streams for restore actions or plain redirects?

  5. ❓ Clarifying Questions

  Before we start coding:

  1. Scheduling Preference: Which job scheduler should I use for the 22:00 daily job?
    - I see Sidekiq is already set up. Should I use sidekiq-cron gem or Heroku Scheduler?
  2. Scope for V1: Should I implement ALL 8 phases for Workers, or stop at inline editing first?
    - (I recommend doing all 8 phases for Workers to have a complete POC)
  3. Models Priority: After Workers, which models should I prioritize?
    - Tasks/SubTasks (nested in Projects)?
    - Machines/Materials (standalone)?
  4. Snapshot Scope: Should snapshots be per-user or per-business?
    - Document mentions both user_id and business_id in schema
    - Page load: per-user makes sense (their editing session)
    - Daily: per-business makes sense (shared "yesterday" state)
  5. Field Selection: Should ALL fields be editable, or specific ones?
    - For Workers: name, email, hourly_rate, profession - all editable?
    - Skip id, created_at, updated_at - obviously
  6. Testing: Do you want me to write automated tests (RSpec/Minitest), or manual testing is fine for V1?

  ---
  My Recommendation: Let's start with Phase 1 (Foundation) once you answer the clarifying questions. This will give us the database structure and
  core concern, then we can test each phase incrementally.

  Ready to proceed when you give me the green light! 🚀