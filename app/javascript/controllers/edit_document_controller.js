import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const fileInput = document.getElementById("file-upload")
    const form = this.element.querySelector("form")
    const documentIdField = document.querySelector("[name='document[document_id]']")

    if (fileInput) {
      fileInput.addEventListener("change", (event) => {
        this.handleFileSelection(event)
        fileInput.setCustomValidity("") // reset greške ako user izabere novi fajl
      })
    }

    if (form && fileInput) {
      form.addEventListener("submit", (e) => {
        const isEditing =
          documentIdField && documentIdField.value && documentIdField.value !== ""

        // ✅ Dozvoli bez fajla ako se edituje postojeći dokument
        if (!isEditing && !fileInput.files.length) {
          e.preventDefault()

          const params = new URLSearchParams(window.location.search)
          const locale = params.get("locale") || "sr"
          const msg =
            locale === "en"
              ? "Please select a file before submitting."
              : "Molimo izaberite fajl prije slanja."

          fileInput.setCustomValidity(msg)
          fileInput.reportValidity()
        } else {
          fileInput.setCustomValidity("") // reset ako sve u redu
        }
      })
    }
  }

  handleFileSelection(event) {
    const file = event.target.files[0]
    const fileNameSpan = document.getElementById("file-name")
    fileNameSpan.textContent = file ? file.name : "Nema fajla"
  }

  loadDocument(event) {
    const documentId = event.target.getAttribute("data-id")

    fetch(`/fetch_data/get_document/${documentId}`)
      .then((response) => response.json())
      .then((data) => {
        document.querySelector("[name='document[name]']").value = data.name
        document.querySelector("[name='document[description]']").value = data.description
        document.querySelector("[name='document[category]']").value = data.category
        document.querySelector("[name='document[document_id]']").value = documentId

        const fileNameSpan = document.getElementById("file-name")
        fileNameSpan.textContent = data.file.filename || "Nema fajla"

        document.querySelector("#documents-modal").classList.remove("hidden")
      })
      .catch((error) => console.error("Error loading document data:", error))
  }
}
