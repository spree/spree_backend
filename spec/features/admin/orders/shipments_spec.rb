require 'spec_helper'

describe 'Shipments', type: :feature do
  stub_authorization!

  let(:store) { Spree::Store.default }
  let!(:order) { create(:order_ready_to_ship, number: 'R100', state: 'complete', line_items_count: 5, store: store) }

  # Regression test for #4025
  context 'a shipment without a shipping method' do
    before do
      order.shipments.each do |s|
        # Deleting the shipping rates causes there to be no shipping methods
        s.shipping_rates.delete_all
      end
    end

    it 'can still be displayed' do
      expect { visit spree.edit_admin_order_path(order) }.not_to raise_error
    end
  end

  context 'shipping an order', js: true do
    before do
      visit spree.admin_orders_path
      within_row(1) do
        click_link 'R100'
      end
    end

    it 'can ship a completed order' do
      click_on 'Ship'

      expect(page).to have_content('shipped package')
      expect(order.reload.shipment_state).to eq('shipped')
    end
  end

  context 'moving variants between shipments', js: true do
    before do
      create(:stock_location, name: 'LA')
      visit spree.admin_orders_path
      within_row(1) do
        click_link 'R100'
      end
    end

    it 'can move a variant to a new and to an existing shipment' do
      expect(order.shipments.count).to eq(1)

      # Non existing shipment
      within_row(1) { click_icon :split }
      select2 'LA', css: '.stock-item-split', search: true, match: :first
      click_icon :save
      wait_for_ajax

      expect(page).to have_css('#order-form-wrapper div', id: /^shipment_\d$/).exactly(2).times
      expect(page).to have_css("#shipment_#{order.shipments.first.id}")

      # Existing shipment
      within_row(2) { click_icon :split }
      select2 "LA(#{order.reload.shipments.last.number})", css: '.stock-item-split', search: true, match: :first
      click_icon :save
      wait_for_ajax

      expect(page).to have_css("#shipment_#{order.reload.shipments.last.id}")
    end
  end
end
