document.addEventListener('turbo:load', function () {
    const themeToggleDarkIcon = document.getElementById('theme-toggle-dark-icon');
    const themeToggleLightIcon = document.getElementById('theme-toggle-light-icon');
    const themeToggleBtn = document.getElementById('theme-toggle');
  
    if (!themeToggleDarkIcon || !themeToggleLightIcon || !themeToggleBtn) {
      // Ako dugme nije pronađeno u DOM-u, izađi iz funkcije
      return;
    }
  
    // Proveri lokalne postavke ili sistemske preferencije
    if (
      localStorage.getItem('color-theme') === 'dark' ||
      (!localStorage.getItem('color-theme') && window.matchMedia('(prefers-color-scheme: dark)').matches)
    ) {
      themeToggleLightIcon.classList.remove('hidden');
    } else {
      themeToggleDarkIcon.classList.remove('hidden');
    }
  
    // Dodaj klik događaj za prebacivanje teme
    themeToggleBtn.addEventListener('click', function () {
      themeToggleDarkIcon.classList.toggle('hidden');
      themeToggleLightIcon.classList.toggle('hidden');
  
      if (document.documentElement.classList.contains('dark')) {
        document.documentElement.classList.remove('dark');
        localStorage.setItem('color-theme', 'light');
      } else {
        document.documentElement.classList.add('dark');
        localStorage.setItem('color-theme', 'dark');
      }
    });
  });
  