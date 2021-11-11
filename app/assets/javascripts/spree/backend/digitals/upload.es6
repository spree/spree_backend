document.addEventListener('DOMContentLoaded', function () {
  const uploadInputs = document.querySelectorAll('input[data-upload-input-id-value]')
  const uploadButtons = document.querySelectorAll('button[data-upload-button-id-value]')

  if (uploadInputs == null || uploadButtons == null) return

  uploadInputs.forEach(element => toggle_upload_button(element))
  uploadButtons.forEach(element => element.disabled = true)
})

function toggle_upload_button(element) {
  element.addEventListener('change', (event) => {
    const uploadInputValue = event.target.dataset.uploadInputIdValue
    const uploadButton = document.querySelector(`[data-upload-button-id-value="${uploadInputValue}"]`)

    uploadButton.disabled = false
  })
}
