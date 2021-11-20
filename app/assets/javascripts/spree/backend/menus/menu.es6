document.addEventListener("spree:load", function() {
  const menuItemSortable = {
    group: {
      name: 'sortable-menu',
      pull: true,
      put: true
    },
    handle: '.move-handle',
    swapThreshold: 0.5,
    emptyInsertThreshold: 8,
    dragClass: 'menu-item-dragged',
    draggable: '.draggable',
    animation: 350,
    forceFallback: false,
    onEnd: function (evt) {
      handleMenuItemMove(evt)
    }
  }

  let containers = null;
  containers = document.querySelectorAll('.menu-container');

  for (let i = 0; i < containers.length; i++) {
    new Sortable(containers[i], menuItemSortable);
  }
})

function handleMenuItemMove(evt) {
  const data = {
    menu_item: {
      new_parent_id: parseInt(evt.to.dataset.parentId, 10) || null,
      new_position_idx: parseInt(evt.newIndex, 10)
    }
  }
  const requestData = {
     uri: `${Spree.routes.menus_items_api_v2}/${evt.item.dataset.itemId}/reposition`,
     method: 'PATCH',
     dataBody: data,
  }
  spreeFetchRequest(requestData)
}
