document.addEventListener('DOMContentLoaded', () => {
  // Radi SAMO za linkove s klasom "delete-item-link"
  document.querySelectorAll('.delete-item-link').forEach(link => {
    link.addEventListener('click', async (event) => {
      event.preventDefault(); // Blokiraj brisanje samo za te linkove

      const itemId = link.dataset.itemId;
      const itemType = link.dataset.itemType;
      if (!itemId || !itemType) return;

      try {
        // Pozovi backend provjeru
        const response = await fetch(`/fetch_data/check_activity/${itemId}/${itemType}`);
        const data = await response.json();

        if (data.has_activities) {
          // 💬 Pripremi poruku
          let message = '';
          if (itemType.toLowerCase() === 'norm') {
            message += `Ova norma se koristi u sljedećim podpozicijama:<br><br>`;
          } else {
            message += `Ovaj element se koristi u sljedećim podpozicijama:<br><br>`;
          }

          data.activity_details.forEach(detail => {
            const subTaskLink = `/businesses/${detail.business_id}/projects/${detail.project_id}/tasks/${detail.task_id}/sub_tasks/${detail.sub_task_id}?#planned`;
            message += `- Projekt: <strong>${detail.project_name}</strong>, Pozicija: ${detail.task_name}, Podpozicija: ${detail.sub_task_name} <a href="${subTaskLink}" target="_blank" class="text-blue-500 font-bold">Otvori</a><br>`;
          });

          // Prikaži modal
          const modal = document.getElementById('delete-modal');
          document.getElementById('delete-modal-message').innerHTML = message;
          modal.classList.remove('hidden');

          // Zatvori dropdown ako je otvoren
          document.querySelectorAll('.dropdown-menu').forEach(menu => menu.classList.add('hidden'));
        } else {
          // Ako je slučajno link imao klasu, ali item ipak nije zauzet (edge case)
          const proceed = confirm('Are you sure you want to delete this item?');
          if (proceed) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = link.href;

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
      } catch (error) {
        console.error('Greška prilikom provjere povezanosti:', error);
      }
    });
  });

  // Zatvori modal na klik dugmeta
  const closeBtn = document.getElementById('delete-modal-close');
  if (closeBtn) {
    closeBtn.addEventListener('click', () => {
      document.getElementById('delete-modal').classList.add('hidden');
    });
  }
});


document.addEventListener("turbo:load", function () {
  // Pokupi locale iz URL-a (?locale=sr ili ?locale=en)
  const params = new URLSearchParams(window.location.search);
  const locale = params.get("locale") || "sr"; // default sr ako nije postavljeno

  // Definiši poruke po jeziku
  const messages = {
    sr: "Molimo popunite ovo polje.",
    en: "Please fill out this field."
  };

  document.querySelectorAll("input[required], textarea[required], select[required]").forEach(function (el) {
    el.oninvalid = function () {
      this.setCustomValidity(messages[locale] || messages["sr"]);
    };
    el.oninput = function () {
      this.setCustomValidity("");
    };
  });
});