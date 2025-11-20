class AddCascadeDeleteToProjectHierarchy < ActiveRecord::Migration[7.0]
  def up
    # Remove existing foreign keys and re-add with ON DELETE CASCADE

    # Tasks -> Projects
    remove_foreign_key :tasks, :projects
    add_foreign_key :tasks, :projects, on_delete: :cascade

    # SubTasks -> Tasks
    remove_foreign_key :sub_tasks, :tasks
    add_foreign_key :sub_tasks, :tasks, on_delete: :cascade

    # Activities -> SubTasks
    remove_foreign_key :activities, :sub_tasks
    add_foreign_key :activities, :sub_tasks, on_delete: :cascade

    # RealActivities -> SubTasks
    remove_foreign_key :real_activities, :sub_tasks
    add_foreign_key :real_activities, :sub_tasks, on_delete: :cascade

    # CustomResources -> SubTasks
    remove_foreign_key :custom_resources, :sub_tasks
    add_foreign_key :custom_resources, :sub_tasks, on_delete: :cascade

    # Documents -> Projects
    remove_foreign_key :documents, :projects
    add_foreign_key :documents, :projects, on_delete: :cascade

    # Documents -> Tasks
    remove_foreign_key :documents, :tasks
    add_foreign_key :documents, :tasks, on_delete: :cascade

    # Documents -> SubTasks
    remove_foreign_key :documents, :sub_tasks
    add_foreign_key :documents, :sub_tasks, on_delete: :cascade

    # SubTaskNorms -> SubTasks
    remove_foreign_key :sub_task_norms, :sub_tasks
    add_foreign_key :sub_task_norms, :sub_tasks, on_delete: :cascade
  end

  def down
    # Revert to default (RESTRICT) foreign keys

    # Tasks -> Projects
    remove_foreign_key :tasks, :projects
    add_foreign_key :tasks, :projects

    # SubTasks -> Tasks
    remove_foreign_key :sub_tasks, :tasks
    add_foreign_key :sub_tasks, :tasks

    # Activities -> SubTasks
    remove_foreign_key :activities, :sub_tasks
    add_foreign_key :activities, :sub_tasks

    # RealActivities -> SubTasks
    remove_foreign_key :real_activities, :sub_tasks
    add_foreign_key :real_activities, :sub_tasks

    # CustomResources -> SubTasks
    remove_foreign_key :custom_resources, :sub_tasks
    add_foreign_key :custom_resources, :sub_tasks

    # Documents -> Projects
    remove_foreign_key :documents, :projects
    add_foreign_key :documents, :projects

    # Documents -> Tasks
    remove_foreign_key :documents, :tasks
    add_foreign_key :documents, :tasks

    # Documents -> SubTasks
    remove_foreign_key :documents, :sub_tasks
    add_foreign_key :documents, :sub_tasks

    # SubTaskNorms -> SubTasks
    remove_foreign_key :sub_task_norms, :sub_tasks
    add_foreign_key :sub_task_norms, :sub_tasks
  end
end
