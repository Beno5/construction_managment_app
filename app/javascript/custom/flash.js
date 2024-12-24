document.addEventListener('turbo:load', () => {
    const flash = document.getElementById('flash-messages');
    if (flash) {
        setTimeout(() => {
            flash.style.transition = 'opacity 1s ease';
            flash.style.opacity = '0';
            setTimeout(() => flash.remove(), 1000);
        }, 3000);
    }
});
