require 'spec_helper'

describe 'Orders Listing', type: :feature do
  stub_authorization!

  let(:other_store) { create(:store, name: 'Other Store', url: 'another-store.lvh.me') }

  let(:order1) do
    create :order_with_line_items,
           created_at: 1.day.from_now,
           completed_at: 1.day.from_now,
           considered_risky: true,
           number: 'R100'
  end

  let(:order2) do
    create :order,
           created_at: 1.day.ago,
           completed_at: 1.day.ago,
           number: 'R200'
  end

  let(:order3) do
    create :order,
           store: other_store,
           created_at: 1.day.ago,
           completed_at: 1.day.ago,
           number: 'R300'
  end

  let(:order4) do
    create :order,
           store: other_store,
           created_at: 1.day.ago,
           completed_at: 1.day.ago,
           number: 'R400'
  end

  before do
    allow_any_instance_of(Spree::OrderInventory).to receive(:add_to_shipment)
    # create the order instances after stubbing the `add_to_shipment` method
    order1
    order2
    order3
    order4
    visit spree.admin_orders_path
  end

  describe 'listing orders' do
    it 'lists existing orders' do
      within_row(1) do
        expect(column_text(1)).to eq 'R100'
        expect(find('td:nth-child(3)')).to have_css '.badge-considered_risky'
        expect(column_text(4)).to eq 'balance due'
      end

      within_row(2) do
        expect(column_text(1)).to eq 'R200'
        expect(find('td:nth-child(3)')).to have_css '.badge-considered_safe'
      end
    end

    it 'does not show the order that belongs to the other_store' do
      expect(page).not_to have_content('R300')
      expect(page).not_to have_content('R400')
    end
  end

  describe 'switching store', js: true do
    it 'shows orders from the current store only' do
      expect(page).to have_content('R100')
      expect(page).to have_content('R200')

      visit spree.admin_orders_path

      Capybara.app_host = 'http://another-store.lvh.me'

      find('a#storeSelectorDropdown').click
      within('.dropdown-menu') { click_link other_store.unique_name }

      expect(current_url).to match('another-store.lvh.me')

      visit spree.admin_orders_path

      expect(page).to have_content('R300')
      expect(page).to have_content('R400')

      expect(page).not_to have_content('R100')
      expect(page).not_to have_content('R200')

      Capybara.app_host = nil
    end
  end

  describe 'searching orders' do
    it 'is able to search orders' do
      fill_in 'q_number_cont', with: 'R200'
      click_on 'Filter Results'
      within_row(1) do
        expect(page).to have_content('R200')
      end

      # Ensure that the other order doesn't show up
      within('table#listing_orders') { expect(page).not_to have_content('R100') }
    end

    it 'returns complete orders only' do
      Spree::Order.create! email: 'incomplete@example.com', completed_at: nil, state: 'cart'
      click_on 'Filters'
      expect(page).to have_content('R200')
      expect(page).not_to have_content('incomplete@example.com')
    end

    it 'is able to filter on variant_sku' do
      click_on 'Filters'
      fill_in 'q_line_items_variant_sku_eq', with: order1.line_items.first.variant.sku
      click_on 'Filter Results'

      within_row(1) do
        expect(page).to have_content(order1.number)
      end

      expect(page).not_to have_content(order2.number)
    end

    context 'when pagination is really short' do
      before do
        @old_per_page = Spree::Backend::Config[:admin_orders_per_page]
        Spree::Backend::Config[:admin_orders_per_page] = 1
      end

      after do
        Spree::Backend::Config[:admin_orders_per_page] = @old_per_page
      end

      # Regression test for #4004
      it 'is able to go from page to page for incomplete orders' do
        Spree::Order.destroy_all
        2.times { Spree::Order.create! email: 'incomplete@example.com', completed_at: nil, state: 'cart' }
        within('#main-sidebar') do
          click_link 'Orders'
          click_link 'Draft Orders'
        end
        within('.pagination', match: :first) do
          click_link '2'
        end
        expect(page).to have_content('incomplete@example.com')
      end
    end

    it 'is able to search orders using only completed at input' do
      fill_in 'q_created_at_gt', with: Date.current
      click_on 'Filter Results'

      within_row(1) { expect(page).to have_content('R100') }

      # Ensure that the other order doesn't show up
      within('table#listing_orders') { expect(page).not_to have_content('R200') }
    end

    context 'filter on promotions' do
      let!(:promotion) { create(:promotion_with_item_adjustment) }

      before do
        order1.promotions << promotion
        order1.save
        visit spree.admin_orders_path
      end

      it 'only shows the orders with the selected promotion' do
        select promotion.name, from: 'Promotion'
        click_on 'Filter Results'
        within_row(1) { expect(page).to have_content('R100') }
        within('table#listing_orders') { expect(page).not_to have_content('R200') }
      end
    end

    it 'is able to apply a ransack filter by clicking a quickfilter icon', js: true do
      label_pending = page.find '.badge-pending'
      parent_td = label_pending.find(:xpath, '..')

      # Click the quick filter Pending for order #R100
      within(parent_td) do
        find('.js-add-filter').click
      end

      expect(page).to have_content('R100')
      expect(page).not_to have_content('R200')
    end

    context 'filter on shipment state' do
      it 'only shows the orders with the selected shipment state' do
        select Spree.t("payment_states.#{order1.shipment_state}"), from: 'Shipment State'
        click_on 'Filter Results'
        within_row(1) { expect(page).to have_content('R100') }
        within('table#listing_orders') { expect(page).not_to have_content('R200') }
      end
    end

    context 'filter on payment state' do
      it 'only shows the orders with the selected payment state' do
        select Spree.t("payment_states.#{order1.payment_state}"), from: 'Payment State'
        click_on 'Filter Results'
        within_row(1) { expect(page).to have_content('R100') }
        within('table#listing_orders') { expect(page).not_to have_content('R200') }
      end
    end

    # regression tests for https://github.com/spree/spree/issues/6888
    context 'per page dropdown', js: true do
      before do
        within('div.index-pagination-row', match: :first) do
          select '50', from: 'per_page'
        end
        expect(page).to have_select('per_page', selected: '50')
        expect(page).to have_selector(:css, 'select.per-page-selected-50')
      end

      it 'adds per_page parameter to url' do
        expect(page).to have_current_path(/per_page=50/)
      end

      it 'can be used with search filtering' do
        click_on 'Filters'
        fill_in 'q_number_cont', with: 'R200'
        click_on 'Filter Results'
        expect(page).not_to have_content('R100')
        within_row(1) { expect(page).to have_content('R200') }
        expect(page).to have_current_path(/per_page=50/)
        expect(page).to have_select('per_page', selected: '50')
        within('div.index-pagination-row', match: :first) do
          select '75', from: 'per_page'
        end
        expect(page).to have_current_path(/per_page=75/)
        expect(page).to have_select('per_page', selected: '75')
        expect(page).to have_selector(:css, 'select.per-page-selected-75')
        expect(page).not_to have_content('R100')
        within_row(1) { expect(page).to have_content('R200') }
      end
    end

    context 'filtering orders', js: true do
      let(:promotion) { create(:promotion_with_item_adjustment) }

      before do
        order1.promotions << promotion
        order1.save
        visit spree.admin_orders_path
      end

      it 'renders selected filters' do
        click_on 'Filters'

        within('#table-filter') do
          select2 'cart', from: 'Status'
          select2 'paid', from: 'Payment State'
          select2 'pending', from: 'Shipment State'
          fill_in 'q_number_cont', with: 'R100'
          fill_in 'q_email_cont', with: 'john_smith@example.com'
          fill_in 'q_line_items_variant_sku_eq', with: 'BAG-00001'
          select2 'Promo', from: 'Promotion'
          fill_in 'q_bill_address_firstname_start', with: 'John'
          fill_in 'q_bill_address_lastname_start', with: 'Smith'
          select2 'spree', from: 'Channel'
        end

        fill_in_date_picker('q_created_at_gt', { year: 2018, month: 1, day: 18 })
        fill_in_date_picker('q_created_at_lt', { year: 2019, month: 3, day: 25 })

        click_on 'Filter Results'

        within('.table-active-filters') do
          expect(page).to have_content('Start: 2018-01-18')
          expect(page).to have_content('Stop: 2019-03-25')
          expect(page).to have_content('Order Number: R100')
          expect(page).to have_content('Status: cart')
          expect(page).to have_content('Payment State: paid')
          expect(page).to have_content('Shipment State: pending')
          expect(page).to have_content('First Name Begins With: John')
          expect(page).to have_content('Last Name Begins With: Smith')
          expect(page).to have_content('Promotion: Promo')
          expect(page).to have_content('Email: john_smith@example.com')
          expect(page).to have_content('SKU: BAG-00001')
          expect(page).to have_content('Channel: spree')
        end
      end
    end
  end

  describe 'Orders index tabs' do
    context 'all orders' do
      let!(:incomplete_order) { create(:order, store: order1.store, number: 'R500') }

      before do
        within('#spreePageTabs') do
          click_link 'All'
        end
      end

      it 'shows all the complete orders for the store' do
        expect(page).to have_content('R100')
        expect(page).to have_content('R200')
        expect(page).not_to have_content('R500')
      end
    end

    context 'unpaid orders' do
      let!(:paid_order) { create(:order_ready_to_ship, store: order1.store, number: 'R500') }

      before do
        order2.update(payment_state: 'void')
        within('#spreePageTabs') do
          click_link 'Unpaid'
        end
      end

      it 'shows all orders that are completed and not paid' do
        expect(page).to have_content('R100')
        expect(page).to have_content('R200')
        expect(page).not_to have_content('R500')
      end
    end

    context 'unfulfilled orders' do
      let!(:shipped_order) { create(:shipped_order, store: order1.store, number: 'R500') }

      before do
        order2.update(shipment_state: 'ready')
        within('#spreePageTabs') do
          click_link 'Unfulfilled'
        end
      end

      it 'shows all orders that are completed and not shipped' do
        expect(page).to have_content('R100')
        expect(page).to have_content('R200')
        expect(page).not_to have_content('R500')
      end
    end
  end

  describe 'from main menu' do
    let!(:complete_order) { create(:order, store: order1.store, completed_at: 1.day.ago) }
    let!(:draft_order) { create(:order, store: order1.store, completed_at: nil, state: 'cart') }
    let!(:abandoned_checkout) { create(:order, store: order1.store, completed_at: nil, state: 'delivery') }

    before do
      within('#main-sidebar') do
        click_link 'Orders'
      end
    end

    context 'when on All Orders page' do
      it 'shows all complete orders' do
        click_link 'All Orders'
        expect(page).to have_content(complete_order.number)
      end
    end

    context 'when on Draft Orders page' do
      it 'shows all orders that are not complete with state=cart' do
        click_link 'Draft Orders'
        expect(page).to have_content(draft_order.number)
      end
    end

    context 'when on Abandoned Checkouts page' do
      it 'shows all complete orders' do
        click_link 'Abandoned Checkouts'
        expect(page).to have_content(abandoned_checkout.number)
      end
    end
  end
end
