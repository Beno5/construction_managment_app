document.addEventListener("DOMContentLoaded", function () {
  const ganttElement = document.getElementById("gantt_here");

  // Proveravamo da li postoji element "gantt_here"
  if (!ganttElement) {
    return; // Ako element ne postoji, ne pokrećemo Gantt
  }


  gantt.config.date_format = "%Y-%m-%d %H:%i:%s";

  // Skala - prikazujemo mjesece
  gantt.config.scales = [
    { unit: "month", step: 1, format: "%F %Y" } // Mjeseci u glavnom zaglavlju
  ];

  // Onemogućavamo sve osim pravljenja linkova
  gantt.config.drag_resize = false;
  gantt.config.drag_move = false;
  gantt.config.drag_progress = false;
  gantt.config.drag_links = true; // ✅ Dozvoljeno povezivanje taskova
  gantt.config.date_grid = "%d.%m.%Y"; // Format datuma u tabeli (gridu)
  gantt.config.lightbox = false;


  gantt.init("gantt_here");

  const projectId = ganttElement.dataset.projectId;
  gantt.load(`/api/gantt/project/${projectId}/data`);

  let selectedLinkId = null;
  

  // Pamti ID linka pre nego što se otvori modal
  gantt.attachEvent("onBeforeLinkDelete", function (id) {
    selectedLinkId = id;
    return true;
  });

  // Kada se klikne na OK dugme, brišemo link preko API-ja
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
  
    return true; // Omogućava Gantt-u da završi dodavanje linka
  });
});
