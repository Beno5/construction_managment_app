import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["taskPosition", "subtaskPosition"]
  static values = {
    tasksUrl: String,
    subtasksUrlTemplate: String
  }

  connect() {
    this.draggingTaskRow = null
    this.draggingSubtaskRow = null
    this.dropIndicatorRow = null
    this.setupListeners()
  }

  setupListeners() {
    this.taskRows().forEach((row) => {
      row.addEventListener("dragstart", this.onTaskDragStart)
      row.addEventListener("dragover", this.onTaskDragOver)
      row.addEventListener("drop", this.onTaskDrop)
      row.addEventListener("dragend", this.onDragEnd)
      // Allow subtasks to drop onto task rows (append to the end)
      row.addEventListener("dragover", this.onSubtaskDragOver)
      row.addEventListener("drop", this.onSubtaskDrop)
    })

    this.subtaskRows().forEach((row) => {
      row.addEventListener("dragstart", this.onSubtaskDragStart)
      row.addEventListener("dragover", this.onSubtaskDragOver)
      row.addEventListener("drop", this.onSubtaskDrop)
      row.addEventListener("dragend", this.onDragEnd)
    })
  }

  taskRows() {
    return Array.from(this.element.querySelectorAll("tr[data-task-id]"))
  }

  subtaskRows() {
    return Array.from(this.element.querySelectorAll("tr[data-subtask-id]"))
  }

  subtaskRowsForTask(taskId) {
    return Array.from(
      this.element.querySelectorAll(`tr[data-subtask-id][data-parent-task-id="${taskId}"]`)
    )
  }

  onTaskDragStart = (event) => {
    this.draggingTaskRow = event.currentTarget
    event.dataTransfer.effectAllowed = "move"
    this.draggingTaskRow.classList.add("task-dragging")
  }

  onTaskDragOver = (event) => {
    if (!this.draggingTaskRow) return
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
    const targetRow = event.currentTarget
    if (targetRow === this.draggingTaskRow) return

    const rect = targetRow.getBoundingClientRect()
    const insertBefore = event.clientY < rect.top + rect.height / 2
    const referenceRow = insertBefore ? targetRow : this.lastRowOfTask(targetRow).nextSibling

    this.showDropIndicator(referenceRow || null, targetRow)
  }

  onTaskDrop = (event) => {
    if (!this.draggingTaskRow) return
    event.preventDefault()
    const targetRow = event.currentTarget
    if (targetRow === this.draggingTaskRow) return

    const rect = targetRow.getBoundingClientRect()
    const insertBefore = event.clientY < rect.top + rect.height / 2

    this.moveTaskGroup(this.draggingTaskRow, targetRow, insertBefore)
    this.refreshTaskIndices()
    this.sendTaskOrderUpdate()
    this.clearHighlights()
    this.clearDropIndicator()
    this.draggingTaskRow.classList.remove("task-dragging")
    this.draggingTaskRow = null
  }

  onSubtaskDragStart = (event) => {
    this.draggingSubtaskRow = event.currentTarget
    event.dataTransfer.effectAllowed = "move"
    this.draggingSubtaskRow.classList.add("task-dragging")
  }

  onSubtaskDragOver = (event) => {
    if (!this.draggingSubtaskRow) return
    event.preventDefault()
    event.dataTransfer.dropEffect = "move"
    const targetRow = event.currentTarget

    let targetTaskRow = null
    let targetSubtaskRow = null

    if (targetRow.dataset.taskId) {
      targetTaskRow = targetRow
    } else if (targetRow.dataset.parentTaskId) {
      targetTaskRow = this.findTaskRow(targetRow.dataset.parentTaskId)
      targetSubtaskRow = targetRow
    }

    if (!targetTaskRow) return

    let referenceRow = null
    if (targetSubtaskRow) {
      const rect = targetSubtaskRow.getBoundingClientRect()
      const insertBefore = event.clientY < rect.top + rect.height / 2
      referenceRow = insertBefore ? targetSubtaskRow : targetSubtaskRow.nextSibling
    } else {
      referenceRow = this.lastRowOfTask(targetTaskRow).nextSibling
    }

    this.showDropIndicator(referenceRow || null, targetRow)
  }

  onSubtaskDrop = (event) => {
    if (!this.draggingSubtaskRow) return
    event.preventDefault()
    const targetRow = event.currentTarget

    // Determine target task row and target subtask row
    let targetTaskRow = null
    let targetSubtaskRow = null

    if (targetRow.dataset.taskId) {
      targetTaskRow = targetRow
    } else if (targetRow.dataset.parentTaskId) {
      targetTaskRow = this.findTaskRow(targetRow.dataset.parentTaskId)
      targetSubtaskRow = targetRow
    }

    if (!targetTaskRow) return

    let insertBefore = false
    if (targetSubtaskRow) {
      const rect = targetSubtaskRow.getBoundingClientRect()
      insertBefore = event.clientY < rect.top + rect.height / 2
    }

    const originTaskId = this.draggingSubtaskRow.dataset.parentTaskId
    this.moveSubtaskRow(this.draggingSubtaskRow, targetTaskRow, targetSubtaskRow, insertBefore)
    this.refreshTaskIndices()

    // Update orders for both origin and destination tasks
    const targetTaskId = targetTaskRow.dataset.taskId
    const uniqueTasks = Array.from(new Set([originTaskId, targetTaskId])).filter(Boolean)
    uniqueTasks.forEach((taskId) => this.sendSubtaskOrderUpdate(taskId))

    this.clearHighlights()
    this.clearDropIndicator()
    this.draggingSubtaskRow.classList.remove("task-dragging")
    this.draggingSubtaskRow = null
  }

  onDragEnd = () => {
    if (this.draggingTaskRow) this.draggingTaskRow.classList.remove("task-dragging")
    if (this.draggingSubtaskRow) this.draggingSubtaskRow.classList.remove("task-dragging")
    this.clearHighlights()
    this.clearDropIndicator()
    this.draggingTaskRow = null
    this.draggingSubtaskRow = null
  }

  moveTaskGroup(draggedTaskRow, targetTaskRow, insertBefore) {
    const draggedTaskId = draggedTaskRow.dataset.taskId
    const targetTaskId = targetTaskRow.dataset.taskId
    if (!draggedTaskId || !targetTaskId) return

    const draggedSubtasks = this.subtaskRowsForTask(draggedTaskId)
    const block = [draggedTaskRow, ...draggedSubtasks]

    // Remove current block from DOM
    block.forEach((row) => row.parentNode.removeChild(row))

    // Determine reference for insertion
    const parent = targetTaskRow.parentNode
    const referenceRow = insertBefore ? targetTaskRow : this.lastRowOfTask(targetTaskRow).nextSibling

    block.forEach((row) => parent.insertBefore(row, referenceRow))
  }

  moveSubtaskRow(draggedSubtaskRow, targetTaskRow, targetSubtaskRow, insertBefore) {
    const tbody = this.element
    draggedSubtaskRow.parentNode.removeChild(draggedSubtaskRow)
    draggedSubtaskRow.dataset.parentTaskId = targetTaskRow.dataset.taskId

    const targetIndex = targetTaskRow.dataset.taskIndex || 0
    draggedSubtaskRow.className = draggedSubtaskRow.className.replace(
      /sub-tasks-of-\d+/,
      `sub-tasks-of-${targetIndex}`
    )

    let reference = null
    if (targetSubtaskRow) {
      reference = insertBefore ? targetSubtaskRow : targetSubtaskRow.nextSibling
    } else {
      reference = this.lastRowOfTask(targetTaskRow).nextSibling
    }

    tbody.insertBefore(draggedSubtaskRow, reference)
  }

  lastRowOfTask(taskRow) {
    let current = taskRow
    while (
      current.nextElementSibling &&
      !current.nextElementSibling.dataset.taskId
    ) {
      current = current.nextElementSibling
    }
    return current
  }

  findTaskRow(taskId) {
    return this.element.querySelector(`tr[data-task-id="${taskId}"]`)
  }

  refreshTaskIndices() {
    this.taskRows().forEach((taskRow, taskIndex) => {
      taskRow.dataset.taskIndex = taskIndex
      const taskPosition = taskRow.querySelector('[data-task-drag-target="taskPosition"]')
      if (taskPosition) taskPosition.textContent = taskIndex + 1

      const toggleButton = taskRow.querySelector(".toggle-sub-tasks")
      if (toggleButton) toggleButton.dataset.target = `.sub-tasks-of-${taskIndex}`

      const subtasks = this.subtaskRowsForTask(taskRow.dataset.taskId)
      subtasks.forEach((subtaskRow, subIndex) => {
        subtaskRow.dataset.parentTaskId = taskRow.dataset.taskId
        subtaskRow.className = subtaskRow.className.replace(
          /sub-tasks-of-\d+/,
          `sub-tasks-of-${taskIndex}`
        )

        const subPosition = subtaskRow.querySelector('[data-task-drag-target="subtaskPosition"]')
        if (subPosition) subPosition.textContent = `${taskIndex + 1}.${subIndex + 1}`
      })
    })
  }

  sendTaskOrderUpdate() {
    if (!this.tasksUrlValue) return
    const order = this.taskRows().map((row, index) => ({
      id: row.dataset.taskId,
      position: index + 1
    }))

    this.fetchJson(this.tasksUrlValue, { order })
  }

  sendSubtaskOrderUpdate(taskId) {
    if (!this.subtasksUrlTemplateValue || !taskId) return
    const url = this.subtasksUrlTemplateValue.replace("TASK_ID", taskId)
    const subTasks = this.subtaskRowsForTask(taskId).map((row, index) => ({
      id: row.dataset.subtaskId,
      position: index + 1
    }))

    this.fetchJson(url, { task_id: taskId, sub_tasks: subTasks })
  }

  fetchJson(url, body) {
    fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        "X-CSRF-Token": this.csrfToken()
      },
      body: JSON.stringify(body)
    }).catch(() => {
      // Fail silently but keep UI updated
    })
  }

  csrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.content : ""
  }

  highlightTarget(row) {
    if (!row || row === this.draggingTaskRow || row === this.draggingSubtaskRow) return
    this.clearHighlights()
    row.classList.add("task-drag-hover")
  }

  clearHighlights() {
    this.element
      .querySelectorAll(".task-drag-hover")
      .forEach((r) => r.classList.remove("task-drag-hover"))
    this.taskRows().forEach((row) => row.classList.remove("task-drag-hover"))
    this.subtaskRows().forEach((row) => row.classList.remove("task-drag-hover"))
  }

  showDropIndicator(referenceRow, sampleRow) {
    const indicator = this.buildDropIndicator(sampleRow)
    const parent = (referenceRow && referenceRow.parentNode) || this.element
    parent.insertBefore(indicator, referenceRow)
  }

  buildDropIndicator(sampleRow) {
    if (!this.dropIndicatorRow) {
      this.dropIndicatorRow = document.createElement("tr")
      this.dropIndicatorRow.classList.add("task-drop-indicator")
      const td = document.createElement("td")
      td.colSpan = sampleRow ? sampleRow.children.length : 12
      this.dropIndicatorRow.appendChild(td)
    } else if (sampleRow) {
      this.dropIndicatorRow.firstElementChild.colSpan = sampleRow.children.length
    }
    return this.dropIndicatorRow
  }

  clearDropIndicator() {
    if (this.dropIndicatorRow && this.dropIndicatorRow.parentNode) {
      this.dropIndicatorRow.parentNode.removeChild(this.dropIndicatorRow)
    }
  }
}
