document.addEventListener("DOMContentLoaded", function () {
  gantt.config.date_format = "%Y-%m-%d %H:%i:%s";
  gantt.init("gantt_here");

  const projectId = document.getElementById("gantt_here").dataset.projectId;
  gantt.load(`/api/gantt/project/${projectId}/data`);

  const dp = new gantt.dataProcessor(`/api/tasks`);
  dp.init(gantt);
  dp.setTransactionMode("REST");

  gantt.attachEvent("onAfterTaskUpdate", function (id, task) {
    const endDate = gantt.date.add(task.start_date, task.duration, "day"); // ✅ Prvo izračunaj
  
    const updatedData = {
      task: {
        text: task.text,
        start_date: gantt.date.date_to_str("%Y-%m-%d %H:%i:%s")(task.start_date),
        end_date: gantt.date.date_to_str("%Y-%m-%d %H:%i:%s")(endDate), // ✅ Ispravno dodato
        duration: task.duration,
        progress: task.progress
      }
    };
  
    console.log("🔄 PUT API CALL: /api/tasks/" + id);
    console.log("📦 Payload:", updatedData);
  
    fetch(`/api/tasks/${id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(updatedData),
    })
      .then((response) => response.json())
      .then((data) => console.log("✅ API Response:", data))
      .catch((error) => console.error("❌ Error updating task:", error));
  });  
});
