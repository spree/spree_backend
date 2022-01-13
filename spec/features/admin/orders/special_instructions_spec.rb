require 'spec_helper'

describe 'Order - Special Instructions', type: :feature do
  stub_authorization!

  let(:store) { Spree::Store.default }
  let!(:order) { create(:order, store: store, special_instructions: 'Some special instructions') }

  context 'when there are special instructions' do
    before do
      visit spree.edit_admin_order_path(order)
    end

    it 'shows the Special Instructions tab' do
      expect(page).to have_link(Spree.t(:special_instructions))
    end

    it 'shows the special instructions' do
      click_link 'Special Instructions'
      expect(page).to have_content(order.special_instructions)
    end
  end

  context 'when there are no special instructions' do
    before do
      order.update(special_instructions: nil)
    end

    it 'does not show the special instructions tab' do
      visit spree.edit_admin_order_path(order)
      expect(page).not_to have_link(Spree.t(:special_instructions))
    end

    it 'shows a notification that there are no special instructions' do
      visit spree.special_instructions_admin_order_path(order)
      expect(page).to have_content(Spree.t('admin.order.no_special_instructions'))
    end
  end
end

