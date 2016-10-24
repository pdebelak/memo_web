function navToggle() {
  const toggles = document.querySelectorAll('.nav-toggle');

  for (let i = 0; i < toggles.length; i++) {
    toggles[i].addEventListener('click', () => {
      const toggle = toggles[i];
      const menu = toggle.parentNode.querySelector('.nav-menu');
      toggle.classList.toggle('is-active');
      menu.classList.toggle('is-active');
    });
  }
}

navToggle();
