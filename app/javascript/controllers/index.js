// Import Stimulus application instance
import { application } from "./application"

// Import all controllers
import ActivityController from "./activity_controller"
import AiImportStatusController from "./ai_import_status_controller"
import AutoDismissController from "./auto_dismiss_controller"
import CustomResourceController from "./custom_resource_controller"
import EditDocumentController from "./edit_document_controller"
import GanttTriggerController from "./gantt_trigger_controller"
import HelloController from "./hello_controller"
import HighlightController from "./highlight_controller"
import LoadingController from "./loading_controller"
import ModalController from "./modal_contoller"
import NormsController from "./norms_controller"
import RealResourcesController from "./real_resources_controller"
import SearchController from "./search_controller"
import SidebarController from "./sidebar_controller"
import SubtaskController from "./subtask_controller"
import ToggleController from "./toggle_controller"
import TrackChangesController from "./track_changes_controller"
import ColumnVisibilityController from "./column_visibility_controller"

// Register controllers
application.register("activity", ActivityController)
application.register("ai-import-status", AiImportStatusController)
application.register("auto-dismiss", AutoDismissController)
application.register("custom-resource", CustomResourceController)
application.register("edit-document", EditDocumentController)
application.register("gantt-trigger", GanttTriggerController)
application.register("hello", HelloController)
application.register("highlight", HighlightController)
application.register("loading", LoadingController)
application.register("modal", ModalController)
application.register("norms", NormsController)
application.register("real-resources", RealResourcesController)
application.register("search", SearchController)
application.register("sidebar", SidebarController)
application.register("subtask", SubtaskController)
application.register("toggle", ToggleController)
application.register("track-changes", TrackChangesController)
application.register("column-visibility", ColumnVisibilityController)
