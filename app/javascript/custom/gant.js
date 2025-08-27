document.addEventListener("DOMContentLoaded", function () {
  const ganttElement = document.getElementById("gantt_here");

  // Ako nema elementa, ne pokrećemo Gantt
  if (!ganttElement) return;

  gantt.config.date_format = "%Y-%m-%d %H:%i:%s";

  // Skala - gore mjeseci, ispod dani
  gantt.config.scales = [
    { unit: "month", step: 1, format: "%F %Y" }, // npr. August 2025
    { unit: "day", step: 1, format: "%d %D" }    // npr. 26 Tue
  ];

  // Onemogućavamo sve osim pravljenja linkova
  gantt.config.drag_progress = false;
  gantt.config.drag_links = true;
  gantt.config.date_grid = "%d.%m.%Y";
  gantt.config.lightbox = false;


  gantt.templates.link_description = function (link) {
    var sourceTask = gantt.getTask(link.source);
    var targetTask = gantt.getTask(link.target);

    var source = sourceTask ? sourceTask.name : link.source;
    var target = targetTask ? targetTask.name : link.target;

    return source + " → " + target;
  };


  // Grid kolone
  gantt.config.columns = [
    {
      name: "position",
      label: "ID",
      width: 80,
      align: "left",
      tree: true
    },
    {
      name: "name",
      label: "Task name",
      width: "*",
      align: "left",
    },
    {
      name: "start_date",
      label: "Start Date",
      align: "center",
      width: 100
    },
    {
      name: "duration",
      label: "Duration",
      align: "center",
      width: 90
    }
  ];

  // Sakrivamo tekst unutar barova
  gantt.templates.task_text = function () { return ""; };

  // Inicijalizacija
  gantt.init("gantt_here");

  const projectId = ganttElement.dataset.projectId;
  gantt.load(`/api/gantt/project/${projectId}/data`);

  let selectedLinkId = null;

  // Pamti ID linka prije brisanja
  gantt.attachEvent("onBeforeLinkDelete", function (id) {
    selectedLinkId = id;
    return true;
  });

  // Kada se potvrdi brisanje
  document.body.addEventListener("click", function (event) {
    if (event.target.closest(".gantt_ok_button") && selectedLinkId) {
      fetch(`/api/links/${selectedLinkId}`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json" }
      })
        .then(response => response.json())
        .then(data => {
          if (data.action === "deleted") {
            gantt.clearAll();
            gantt.load(`/api/gantt/project/${projectId}/data`);
          }
        });

      selectedLinkId = null;
    }
  });

  // Kad korisnik pomjeri task na ganttu
  gantt.attachEvent("onAfterTaskUpdate", function (id, task) {
    fetch(`/api/gantt/move_update/${id}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({
        start_date: gantt.date.date_to_str("%Y-%m-%d")(task.start_date),
        end_date: gantt.date.date_to_str("%Y-%m-%d")(task.end_date),
        duration: task.duration
      })
    })
      .then(r => r.json())
      .then(d => console.log("✅ update:", d))
      .catch(e => console.error("❌ greska:", e));
  });





  // Kada se kreira novi link
  gantt.attachEvent("onLinkCreated", function (link) {
    fetch("/api/links", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        source_id: link.source,
        target_id: link.target,
        link_type: link.type
      })
    })
      .then(response => response.json())
      .then(data => {
        if (data.action === "inserted") {
          gantt.clearAll();
          gantt.load(`/api/gantt/project/${projectId}/data`);
        }
      })
      .catch(error => console.error("❌ API greška:", error));

    return true;
  });
});

// Tooltip helper
function buildTooltip(id, start, end) {
  const template = document.getElementById("gantt-tooltip-template");
  if (!template) return "";

  let html = template.innerHTML;
  html = html.replaceAll("REPLACE_ID", `tooltip-${id}`);
  html = html.replace("REPLACE_START", start || "N/A");
  html = html.replace("REPLACE_END", end || "N/A");

  return html;
}
