import { Controller } from "@hotwired/stimulus";

// Makes table columns sortable with optional row grouping support.
export default class extends Controller {
  static targets = ["header", "arrow"];

  connect() {
    this.currentColumn = null;
    this.direction = "asc";
  }

  sort(event) {
    const header = event.currentTarget.closest("th");
    const columnIndex = Number(header.dataset.sortIndex);

    if (this.currentColumn === columnIndex) {
      this.direction = this.direction === "asc" ? "desc" : "asc";
    } else {
      this.currentColumn = columnIndex;
      this.direction = "asc";
    }

    this.updateArrows();
    this.applySort(columnIndex);
  }

  applySort(columnIndex) {
    const tbody = this.element.querySelector("tbody");
    if (!tbody) return;

    const rows = Array.from(tbody.querySelectorAll(":scope > tr"));
    const groups = this.buildGroups(rows);

    groups.sort((groupA, groupB) => {
      const valueA = this.valueForRow(groupA[0], columnIndex);
      const valueB = this.valueForRow(groupB[0], columnIndex);

      return this.compareValues(valueA, valueB);
    });

    const sortedRows = [];
    groups.forEach((group) => sortedRows.push(...group));
    tbody.replaceChildren(...sortedRows);
  }

  buildGroups(rows) {
    const groups = [];

    for (let i = 0; i < rows.length; i += 1) {
      const row = rows[i];

      if (row.dataset.sortChild === "true") continue;

      if (row.dataset.sortParent === "true") {
        const groupRows = [row];
        const groupId = row.dataset.sortGroup;
        let j = i + 1;

        while (
          j < rows.length &&
          rows[j].dataset.sortGroup === groupId &&
          rows[j].dataset.sortParent !== "true"
        ) {
          groupRows.push(rows[j]);
          j += 1;
        }

        groups.push(groupRows);
        i = j - 1;
      } else {
        groups.push([row]);
      }
    }

    return groups;
  }

  valueForRow(row, columnIndex) {
    const cell = row.querySelector(`:scope > *:nth-child(${columnIndex + 1})`);
    const rawValue = cell?.dataset.sortValue ?? cell?.textContent ?? "";
    return rawValue.toString().trim().toLowerCase();
  }

  compareValues(a, b) {
    const numericA = parseFloat(a);
    const numericB = parseFloat(b);
    const bothNumeric = !Number.isNaN(numericA) && !Number.isNaN(numericB);

    if (bothNumeric) {
      return this.direction === "asc" ? numericA - numericB : numericB - numericA;
    }

    return this.direction === "asc" ? a.localeCompare(b) : b.localeCompare(a);
  }

  updateArrows() {
    this.arrowTargets.forEach((arrow) => {
      const arrowIndex = Number(arrow.dataset.sortIndex);
      if (arrowIndex === this.currentColumn) {
        arrow.textContent = this.direction === "asc" ? "↑" : "↓";
        arrow.classList.remove("text-gray-300");
      } else {
        arrow.textContent = "↕";
        arrow.classList.add("text-gray-300");
      }
    });
  }
}
