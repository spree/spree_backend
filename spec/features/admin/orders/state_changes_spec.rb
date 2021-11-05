require 'spec_helper'

describe 'Order - State Changes', type: :feature do
  stub_authorization!

  let(:store) { Spree::Store.default }
  let!(:order) { create(:order_with_line_items, store: store) }

  context 'for completed order' do
    before do
      order.next!
      visit spree.admin_order_state_changes_path(order)
    end

    it 'are viewable' do
      within_row(1) do
        within('td:nth-child(1)') { expect(page).to have_content('Order') }
        within('td:nth-child(2)') { expect(page).to have_content('cart') }
        within('td:nth-child(3)') { expect(page).to have_content('address') }
      end
    end
  end
end
