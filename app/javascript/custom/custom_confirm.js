document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.delete-item-link').forEach(link => {
      link.addEventListener('click', async (event) => {
        event.preventDefault();
        const itemId = event.target.dataset.itemId;
        const itemType = event.target.dataset.itemType;
  
        // Check if the item is associated with any activities
        const response = await fetch(`/fetch_data/check_activity/${itemId}/${itemType}`);
        const data = await response.json();
  
        if (data.has_activities) {
          // Display message with list of projects, tasks, and sub-tasks
          let message = `This ${itemType.toLowerCase()} cannot be deleted because it is occupied in:<br>`;
          data.activity_details.forEach(detail => {
            const subTaskLink = `/businesses/${detail.business_id}/projects/${detail.project_id}/tasks/${detail.task_id}/sub_tasks/${detail.sub_task_id}?#planned`;
            message += `- Project: ${detail.project_name}, Task: ${detail.task_name}, Sub-Task: ${detail.sub_task_name} <a href="${subTaskLink}" target="_blank" class="text-blue-500 font-bold">Open in new tab</a><br>`;
          });
  
          // Show the modal with the message
          document.getElementById('delete-modal-message').innerHTML = message;
          document.getElementById('delete-modal').classList.remove('hidden');
  
          // Close the dropdown
          document.querySelectorAll('.dropdown-menu').forEach(menu => {
            menu.classList.add('hidden');
          });
        } else {
          // Proceed with the standard confirmation dialog
          if (confirm('Are you sure?')) {
            // Create a form dynamically and submit it
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = event.target.href;
  
            const methodInput = document.createElement('input');
            methodInput.type = 'hidden';
            methodInput.name = '_method';
            methodInput.value = 'delete';
            form.appendChild(methodInput);
  
            const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
            const csrfInput = document.createElement('input');
            csrfInput.type = 'hidden';
            csrfInput.name = 'authenticity_token';
            csrfInput.value = csrfToken;
            form.appendChild(csrfInput);
  
            document.body.appendChild(form);
            form.submit();
          }
        }
      });
    });
  
    // Close the modal when the OK button is clicked
    document.getElementById('delete-modal-close').addEventListener('click', () => {
      document.getElementById('delete-modal').classList.add('hidden');
    });
  });