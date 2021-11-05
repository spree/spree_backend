require 'spec_helper'

describe 'Stock Management', type: :feature, js: true do
  stub_authorization!

  context 'given a product with a variant and a stock location' do
    let!(:stock_location) { create(:stock_location, name: 'Default') }
    let!(:product) { create(:product, name: 'apache baseball cap', price: 10) }
    let!(:variant) { product.master }

    before do
      stock_location.stock_item(variant).update_column(:count_on_hand, 10)
      visit spree.stock_admin_product_path(product)
    end

    context "toggle backorderable for a variant's stock item" do
      let(:backorderable) { find_field(class: 'stock_item_backorderable') }

      before do
        expect(backorderable).to be_checked
        backorderable.uncheck
        wait_for_ajax
      end

      it 'persists the value when page reload' do
        refresh
        expect(backorderable).not_to be_checked
      end
    end

    context "toggle track inventory for a variant's stock item" do
      let(:track_inventory) { find_field(class: 'track_inventory_checkbox') }

      before do
        expect(track_inventory).to be_checked
        track_inventory.uncheck
        wait_for_ajax
      end

      it 'persists the value when page reloaded' do
        refresh
        expect(track_inventory).not_to be_checked
      end
    end

    # Regression test for #2896
    # The regression was that unchecking the last checkbox caused a redirect
    # to happen. By ensuring that we're still on an /admin/products URL, we
    # assert that the redirect is *not* happening.
    it 'can toggle backorderable for the second variant stock item' do
      new_location = create(:stock_location, name: 'Another Location')
      refresh

      new_location_backorderable = find_field(id: "stock_item_backorderable_#{new_location.id}", checked: true)
      new_location_backorderable.uncheck
      wait_for_ajax

      expect(page).to have_current_path(%r{/admin/products})
    end

    it 'can create a new stock movement' do
      fill_in 'stock_movement_quantity', with: 5
      click_button 'Add Stock'

      expect(page).to have_content('successfully created')

      within(:css, '.stock_location_info table') do
        expect(column_text(2)).to eq '15'
      end
    end

    it 'can create a new negative stock movement' do
      fill_in 'stock_movement_quantity', with: -5
      click_button 'Add Stock'

      expect(page).to have_content('successfully created')

      within(:css, '.stock_location_info table') do
        expect(column_text(2)).to eq '5'
      end
    end

    context 'with multiple variants' do
      let!(:variant) { create(:variant, product: product, sku: 'SPREEC') }

      before do
        variant.stock_items.first.update_column(:count_on_hand, 30)
        refresh
      end

      it 'can create a new stock movement for the specified variant' do
        fill_in 'stock_movement_quantity', with: 10
        select2 'SPREEC', from: 'Variant'
        click_button 'Add Stock'

        expect(page).to have_content('successfully created')

        within('#listing_product_stock tr', text: 'SPREEC') do
          within('table') do
            expect(column_text(2)).to eq '40'
          end
        end
      end
    end

    # Regression test for #3304
    context 'with no stock location' do
      let(:product) { create(:product, name: 'apache baseball cap', price: 10) }
      let(:variant) { create(:variant, product: product, sku: 'FOOBAR') }

      before do
        Spree::StockLocation.delete_all

        visit spree.stock_admin_product_path(product)
      end

      it 'redirects to stock locations page', js: false do
        expect(page).to have_content(Spree.t(:stock_management_requires_a_stock_location))
        expect(page).to have_current_path(%r{admin/stock_locations})
      end
    end
  end
end
