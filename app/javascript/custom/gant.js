document.addEventListener("DOMContentLoaded", function () {
    gantt.config.date_format = "%Y-%m-%d %H:%i:%s";
    gantt.config.scales = [{ unit: "month", step: 1, format: "%F %Y" }];
  
    gantt.attachEvent("onLoadEnd", function () {
      const tasks = gantt.getTaskByTime();
      if (tasks.length > 0) {
        const minDate = gantt.getTaskStart(tasks[0].id);
        const maxDate = gantt.date.add(minDate, 1, "year");
        gantt.config.start_date = minDate;
        gantt.config.end_date = maxDate;
        gantt.render();
      }
    });
  
    gantt.init("gantt_here");
    gantt.load("/api/data");
  
    const dp = new gantt.dataProcessor("/api");
    dp.init(gantt);
    dp.setTransactionMode("REST");
  });
  