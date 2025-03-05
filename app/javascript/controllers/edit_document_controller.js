import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("Edit document controller connected");

    // Attach event listener to the file input
    const fileInput = document.getElementById("file-upload");
    if (fileInput) {
      fileInput.addEventListener("change", (event) => this.handleFileSelection(event));
    }
  }

  // Handle file selection
  handleFileSelection(event) {
    const file = event.target.files[0];
    const fileNameSpan = document.getElementById("file-name"); // Get the span element
    if (file) {
      fileNameSpan.textContent = file.name; // Update the span with the file name
    } else {
      fileNameSpan.textContent = "No file selected";
    }
  }

  // Load document data for editing
  loadDocument(event) {
    const documentId = event.target.getAttribute('data-id'); 

    // Fetch document data from the new route
    fetch(`/fetch_data/get_document/${documentId}`)
      .then(response => response.json())
      .then(data => {
        // Fill in the form with the fetched data
        document.querySelector("[name='document[name]']").value = data.name;
        document.querySelector("[name='document[description]']").value = data.description;
        document.querySelector("[name='document[category]']").value = data.category;
        document.querySelector("[name='document[document_id]']").value = documentId;

        // Display the existing file name in the span
        const fileNameSpan = document.getElementById("file-name");
        fileNameSpan.textContent = data.file.filename || "No file selected";

        // Open the modal
        document.querySelector('#documents-modal').classList.remove('hidden');
      })
      .catch(error => console.error("Error loading document data:", error));
  }
}