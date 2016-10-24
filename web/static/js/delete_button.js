function deleteButton() {
  const deletes = document.querySelectorAll('button.delete');

  for (let i = 0; i < deletes.length; i++) {
    deletes[i].addEventListener('click', () => {
      const parent = deletes[i].parentNode;
      parent.parentNode.removeChild(parent);
    });
  }
}

deleteButton();
