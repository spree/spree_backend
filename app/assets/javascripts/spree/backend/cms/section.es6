document.addEventListener("spree:load", function() {
  const sectionKindSelector = $('#cms_section_type').select2()
  const layoutSwitcher = $('#cms_section_layout_style').select2()

  sectionKindSelector.on('change', function() {
    const selectedValue = $(sectionKindSelector).val()
    const message = document.getElementById('alertToClickUpdate')
    const activeSectionKind = document.getElementById('CmsSectionType')

    if (!activeSectionKind) return

    const panelType = activeSectionKind.dataset.panelSectionType

    if (selectedValue === panelType) {
      activeSectionKind.classList = ''
      activeSectionKind.classList.add('d-block')

      message.classList = ''
      message.classList.add('d-none')
    } else {
      activeSectionKind.classList = ''
      activeSectionKind.classList.add('d-none')

      message.classList = ''
      message.classList.add('d-block')
    }
  });

  if (!layoutSwitcher) return

  layoutSwitcher.on('change', function() {
    const layoutDefault = document.querySelector('#Default')
    const layoutReverse = document.querySelector('#Reversed')

    if (this.value === 'Default') {
      layoutDefault.classList = 'd-block'
      layoutReverse.classList = 'd-none'
    } else {
      layoutDefault.classList = 'd-none'
      layoutReverse.classList = 'd-block'
    }
  })
})
