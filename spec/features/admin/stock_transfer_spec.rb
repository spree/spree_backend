require 'spec_helper'

describe 'Stock Transfers', type: :feature, js: true do
  stub_authorization!

  let!(:product) { create(:product_in_stock, sku: 'A99400', description: 'lorem ipsum') }
  let!(:variant) { create(:variant, product: product, sku: 'MIOD') }

  it 'shows variants with options text' do
    create(:stock_location_with_items, name: 'NY')
    variant.set_option_value('Color', 'Green')

    visit spree.admin_stock_transfers_path
    click_on 'New Stock Transfer'

    expected_select_item = "#{variant.name} - #{variant.sku} (#{variant.options_text})"
    select2_open label: 'Variant'
    select2_search variant.sku, from: 'Variant'
    select2_select expected_select_item, from: 'Variant', match: :first

    content = "#{variant.name} (#{variant.options_text}) - #{variant.sku}"
    expect(page).to have_content(content)
  end

  # TODO: FIX ME
  xcontext 'ERROR: TODO -> Some variants are not available on Stock location' do
    it 'transfer between 2 locations' do
      create(:stock_location, name: 'SF') # destination_location

      variant = Spree::Variant.last

      visit spree.admin_stock_transfers_path

      click_on 'New Stock Transfer'
      fill_in 'reference', with: 'PO 666'

      select2 variant.stock_locations.first.name, from: 'Source'
      wait_for_turbo
      select2 variant.sku, from: 'Variant', search: true

      click_button 'Add'
      click_button 'Transfer Stock'

      wait_for_turbo

      expect(page).to have_content('Reference PO 666')
      expect(page).to have_content('NY')
      expect(page).to have_content('SF')
      expect(page).to have_content(product.name)

      transfer = Spree::StockTransfer.last
      expect(transfer.stock_movements.size).to eq 2
    end
  end

  it 'does not transfer if variant is not available on hand' do
    create(:stock_location_with_items, name: 'NY') # source_location
    create(:stock_location, name: 'SF') # destination_location

    Spree::StockLocation.first.stock_items.where(variant_id: product.master.id).first.adjust_count_on_hand(0)

    visit spree.admin_stock_transfers_path
    click_on 'New Stock Transfer'

    fill_in 'reference', with: 'PO 666'

    select2_open label: 'Variant'
    select2_search product.master.name, from: 'Variant'
    select2_select product.master.name, from: 'Variant', match: :first

    click_button 'Add'

    click_button 'Transfer Stock'

    expect(page).to have_content('Some variants are not available')
  end

  describe 'received stock transfer' do
    def it_is_received_stock_transfer(page)
      expect(page).to have_content('Reference PO 666')
      expect(page).not_to have_selector('#stock-location-source')
      expect(page).to have_selector('#stock-location-destination')

      transfer = Spree::StockTransfer.last
      expect(transfer.stock_movements.size).to eq 1
      expect(transfer.source_location).to be_nil
    end

    it 'receive stock to a single location' do
      create(:stock_location_with_items, name: 'NY') # source_location
      create(:stock_location, name: 'SF') # destination_location

      visit spree.new_admin_stock_transfer_path

      fill_in 'reference', with: 'PO 666'
      check 'transfer_receive_stock'
      select2 'NY', from: 'Destination'

      select2_open label: 'Variant'
      select2_search variant.name, from: 'Variant'
      select2_select variant.name, from: 'Variant', match: :first

      click_button 'Add'
      click_button 'Transfer Stock'

      it_is_received_stock_transfer page
    end

    # TODO: FIX ME
    xcontext 'ERROR: TODO -> Some variants are not available on Stock location' do
      it 'forced to only receive there is only one location' do
        create(:stock_location_with_items, name: 'NY') # source_location

        visit spree.new_admin_stock_transfer_path

        fill_in 'reference', with: 'PO 666'

        select2 'NY', from: 'Destination'

        select2_open label: 'Variant'
        select2_search variant.name, from: 'Variant'
        select2_select variant.name, from: 'Variant', match: :first

        click_button 'Add'
        click_button 'Transfer Stock'

        it_is_received_stock_transfer page
      end
    end
  end
end
