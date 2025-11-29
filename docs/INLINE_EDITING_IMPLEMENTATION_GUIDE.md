# Inline Editing Implementation Guide

## ✅ Completed Models

The following models now have full inline editing support (controllers + views):

1. **Workers** - index & show views
2. **Machines** - index & show views
3. **Materials** - index & show views
4. **Projects** - controller only (views need data attributes)

## ⚠️ Controllers Updated, Views Pending

The following models have controller support but need view updates:

1. **Tasks**
2. **SubTasks**
3. **Norms**

## How to Add Inline Editing to Views

### Step 1: Update Index View (Table)

For each model's `index.html.erb`, wrap editable table cells with inline-edit data attributes:

```erb
<% # At the top of the file, build enum options if needed %>
<%
  model_name = "Tasks"  # or SubTasks, Norms, etc.

  # For enums (status, unit_of_measure, etc.)
  status_options = Task.statuses.keys.each_with_object({}) do |key, hash|
    hash[key] = I18n.t("activerecord.attributes.task.statuses.#{key}")
  end
%>

<%= render 'partials/header1', ... %>

<section class="bg-gray-50 dark:bg-gray-900 pt-5"
         data-controller="toggle toast"  <%# Add toast controller! %>
         data-section-id="tasks-table"
         data-user-id="<%= current_user.id %>">
  <!-- ... -->

  <% @tasks.each do |task| %>
    <tr id="<%= dom_id(task) %>">

      <!-- Text Field Example -->
      <td class="px-4 py-3 cursor-pointer"
          data-controller="inline-edit"
          data-inline-edit-model-value="task"
          data-inline-edit-field-value="name"
          data-inline-edit-type-value="text"
          data-inline-edit-url-value="<%= business_project_task_path(@current_business, @project, task) %>"
          data-inline-edit-original-value="<%= task.name %>"
          data-inline-edit-record-updated-at-value="<%= task.updated_at.iso8601 %>"
          data-inline-edit-required-value="true"
          data-action="dblclick->inline-edit#activate"
          title="Double-click to edit">
        <%= task.name %>
      </td>

      <!-- Number Field Example -->
      <td class="px-4 py-3 cursor-pointer"
          data-controller="inline-edit"
          data-inline-edit-model-value="task"
          data-inline-edit-field-value="position"
          data-inline-edit-type-value="number"
          data-inline-edit-url-value="<%= business_project_task_path(@current_business, @project, task) %>"
          data-inline-edit-original-value="<%= task.position %>"
          data-inline-edit-record-updated-at-value="<%= task.updated_at.iso8601 %>"
          data-action="dblclick->inline-edit#activate"
          title="Double-click to edit">
        <%= task.position %>
      </td>

      <!-- Date Field Example -->
      <td class="px-4 py-3 cursor-pointer"
          data-controller="inline-edit"
          data-inline-edit-model-value="task"
          data-inline-edit-field-value="planned_start_date"
          data-inline-edit-type-value="date"
          data-inline-edit-url-value="<%= business_project_task_path(@current_business, @project, task) %>"
          data-inline-edit-original-value="<%= task.planned_start_date %>"
          data-inline-edit-record-updated-at-value="<%= task.updated_at.iso8601 %>"
          data-action="dblclick->inline-edit#activate"
          title="Double-click to edit">
        <%= task.planned_start_date %>
      </td>

      <!-- Select/Enum Field Example -->
      <td class="px-4 py-3 cursor-pointer"
          data-controller="inline-edit"
          data-inline-edit-model-value="task"
          data-inline-edit-field-value="status"
          data-inline-edit-type-value="select"
          data-inline-edit-url-value="<%= business_project_task_path(@current_business, @project, task) %>"
          data-inline-edit-original-value="<%= task.status %>"
          data-inline-edit-record-updated-at-value="<%= task.updated_at.iso8601 %>"
          data-inline-edit-options-value='<%= status_options.to_json %>'
          data-action="dblclick->inline-edit#activate"
          title="Double-click to edit">
        <%= t_enum(task, :status) %>
      </td>

      <!-- Textarea Field Example -->
      <td class="px-4 py-3 cursor-pointer"
          data-controller="inline-edit"
          data-inline-edit-model-value="task"
          data-inline-edit-field-value="description"
          data-inline-edit-type-value="textarea"
          data-inline-edit-url-value="<%= business_project_task_path(@current_business, @project, task) %>"
          data-inline-edit-original-value="<%= task.description %>"
          data-inline-edit-record-updated-at-value="<%= task.updated_at.iso8601 %>"
          data-action="dblclick->inline-edit#activate"
          title="Double-click to edit">
        <%= content_tag(:span, task.description&.truncate(25), title: task.description, class: "tooltip") %>
      </td>

      <!-- Actions column stays the same -->
      <td>...</td>
    </tr>
  <% end %>
</section>
```

### Step 2: Update Show View (Form Fields)

For each model's `show.html.erb`, replace form inputs with inline-editable divs:

```erb
<%
  # Build enum options
  status_options = Task.statuses.keys.each_with_object({}) do |key, hash|
    hash[key] = I18n.t("activerecord.attributes.task.statuses.#{key}")
  end
%>

<%= render 'partials/header1', ... %>

<section class="bg-gray-50 dark:bg-gray-900 pt-5"
         data-controller="toggle toast"  <%# Add toast controller! %>
         data-section-id="task-details"
         data-user-id="<%= current_user.id %>">
  <div class="mx-auto">
    <div class="bg-white dark:bg-gray-800 relative shadow-md sm:rounded-lg overflow-hidden p-4">
      <!-- Toggle switch -->
      <div class="flex items-center gap-4 mb-4">
        <h2 class="text-l font-semibold text-gray-900 sm:text-2xl dark:text-white">
          <%= t("businesses.form.basic_information") %>
        </h2>
        <label class="inline-flex items-center cursor-pointer">
          <input type="checkbox" id="task-info-toggle" checked class="sr-only peer"
                 data-action="change->toggle#toggle" data-toggle-target="switch">
          <div class="relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600 dark:peer-checked:bg-blue-600"></div>
        </label>
      </div>

      <div data-toggle-target="content" class="transition-all duration-300">
        <div class="grid grid-cols-6 gap-6">

          <!-- Text Field -->
          <div class="col-span-6 sm:col-span-3">
            <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">
              <%= t('tasks.form.name') %>*
            </label>
            <div class="shadow-sm bg-white border border-gray-300 text-gray-900 sm:text-sm rounded-lg block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:text-white cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-600"
                 data-controller="inline-edit"
                 data-inline-edit-model-value="task"
                 data-inline-edit-field-value="name"
                 data-inline-edit-type-value="text"
                 data-inline-edit-url-value="<%= business_project_task_path(@current_business, @project, @task) %>"
                 data-inline-edit-original-value="<%= @task.name %>"
                 data-inline-edit-record-updated-at-value="<%= @task.updated_at.iso8601 %>"
                 data-inline-edit-required-value="true"
                 data-action="dblclick->inline-edit#activate"
                 title="Double-click to edit">
              <%= @task.name %>
            </div>
          </div>

          <!-- Select Field -->
          <div class="col-span-6 sm:col-span-3">
            <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">
              <%= t('tasks.form.status') %>
            </label>
            <div class="shadow-sm bg-white border border-gray-300 text-gray-900 sm:text-sm rounded-lg block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:text-white cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-600"
                 data-controller="inline-edit"
                 data-inline-edit-model-value="task"
                 data-inline-edit-field-value="status"
                 data-inline-edit-type-value="select"
                 data-inline-edit-url-value="<%= business_project_task_path(@current_business, @project, @task) %>"
                 data-inline-edit-original-value="<%= @task.status %>"
                 data-inline-edit-record-updated-at-value="<%= @task.updated_at.iso8601 %>"
                 data-inline-edit-options-value='<%= status_options.to_json %>'
                 data-action="dblclick->inline-edit#activate"
                 title="Double-click to edit">
              <%= t_enum(@task, :status) %>
            </div>
          </div>

          <!-- Continue for all other fields... -->

        </div>

        <!-- Back Button -->
        <div class="flex items-center justify-end gap-3 pt-6 mt-6 border-t border-gray-200 dark:border-gray-700">
          <%= link_to business_project_tasks_path(@current_business, @project),
              class: "px-6 py-3 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 focus:ring-4 focus:ring-gray-200 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700 dark:focus:ring-gray-700" do %>
            <%= t('tasks.form.back_button', default: 'Back to Tasks') %>
          <% end %>
        </div>
      </div>
    </div>
  </div>
</section>
```

## Field Types Reference

| Field Type | `data-inline-edit-type-value` | Example |
|------------|-------------------------------|---------|
| Text | `"text"` | Name, address, project_manager |
| Number | `"number"` | Position, quantity, price_per_unit, planned_cost |
| Date | `"date"` | planned_start_date, planned_end_date |
| Select | `"select"` | status, unit_of_measure |
| Textarea | `"textarea"` | description, notes |
| Email | `"email"` | email |

## Important Notes

1. **Always add `data-controller="toggle toast"`** to the section element
2. **Always use `record-updated-at-value`** with `<%= record.updated_at.iso8601 %>`
3. **Build enum options** at the top of the view for select fields
4. **Use correct URL** for the model's update path
5. **Mark required fields** with `data-inline-edit-required-value="true"`
6. **Add tooltips** with `title="Double-click to edit"`

## Model-Specific URLs

- **Tasks**: `business_project_task_path(@current_business, @project, task)`
- **SubTasks**: `business_project_task_sub_task_path(@current_business, @project, @task, sub_task)`
- **Norms**: `business_norm_path(@current_business, norm)`

## Testing Checklist

After implementing inline editing for a model:

- [ ] Double-click field enters edit mode (blue border)
- [ ] Enter key saves changes
- [ ] ESC key cancels editing
- [ ] Click outside (blur) saves changes
- [ ] Select dropdown saves immediately on change
- [ ] Successful save shows green border flash + toast
- [ ] Validation errors show red border + error text below field
- [ ] Can edit multiple fields in sequence without conflicts
- [ ] Conflict detection works when editing from two tabs

## See Working Examples

Look at these files for complete working examples:
- `app/views/workers/index.html.erb`
- `app/views/workers/show.html.erb`
- `app/views/machines/index.html.erb`
- `app/views/machines/show.html.erb`
- `app/views/materials/index.html.erb`
- `app/views/materials/show.html.erb`
