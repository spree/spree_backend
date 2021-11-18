document.addEventListener("turbo:load", function() {
  tinymce.remove() // Required for turbo:load

  tinymce.init({
    selector: '.spree-rte',
    plugins: [
      'image table paste code link table'
    ],
    menubar: false,
    toolbar: 'undo redo | styleselect | bold italic link forecolor backcolor | alignleft aligncenter alignright alignjustify | table | bullist numlist outdent indent | code '
  });
})
