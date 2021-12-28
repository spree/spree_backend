require 'spec_helper'

describe 'Users', type: :feature do
  include Spree::BaseHelper
  stub_authorization!
  include Spree::Admin::BaseHelper

  let(:store) { Spree::Store.default }
  let!(:user_a) { create(:user_with_addresses, email: 'a@example.com') }
  let!(:user_b) { create(:user_with_addresses, email: 'b@example.com') }

  let!(:order) { create(:completed_order_with_totals, store: store, user: user_a, number: 'R123') }
  let!(:order_2) do
    create(:completed_order_with_totals, store: store, user: user_a, number: 'R456').tap do |o|
      li = o.line_items.last
      li.update_column(:price, li.price + 10)
    end
  end
  let!(:order_eur) { create(:completed_order_with_totals, store: store, user: user_a, currency: 'EUR') }
  let!(:order_gbp) { create(:completed_order_with_totals, store: store, user: user_a, currency: 'GBP') }
  let!(:orders) { Spree::Order.where(id: [order.id, order_2.id, order_eur.id, order_gbp.id]) }

  let!(:store_credit_usd) { create(:store_credit, amount: '100', store: store, user: user_a, currency: 'USD') }
  let!(:store_credit_eur) { create(:store_credit, amount: '90', store: store, user: user_a, currency: 'EUR') }
  let!(:store_credit_gbp) { create(:store_credit, amount: '80', store: store, user: user_a, currency: 'GBP') }

  shared_examples_for 'a user page' do
    context 'lifetime stats' do
      shared_examples_for 'has lifetime stats' do
        it 'has lifetime stats' do
          within('#user-lifetime-stats') do
            [:total_sales, :num_orders, :average_order_value, :member_since].each do |stat_name|
              expect(page).to have_content Spree.t(stat_name)
            end

            total_sales = "$#{order.total.to_i + order_2.total.to_i}.00 #{order_gbp.display_total} #{order_eur.display_total}"
            total_average = "$#{(order.total.to_i + order_2.total.to_i)/2}.00 #{order_gbp.display_total} #{order_eur.display_total}"
            total_credits = "$#{store_credit_usd.amount.to_i}.00 €#{store_credit_eur.amount.to_i}.00 £#{store_credit_gbp.amount.to_i}.00"
            expect(page).to have_content("Total Sales: #{total_sales}", normalize_ws: true)
            expect(page).to have_content("Average Order Value: #{total_average}", normalize_ws: true)
            expect(page).to have_content("Store Credits: #{total_credits}", normalize_ws: true)
            expect(page).to have_content("# Orders: #{orders.count}", normalize_ws: true)
            expect(page).to have_content("Member Since: #{pretty_time(user_a.created_at).gsub(/[[:space:]]+/, ' ')}", normalize_ws: true)
          end
        end
      end

      it_behaves_like 'has lifetime stats'

      context 'when other store order exits' do
        let(:new_store) { create(:store) }
        let!(:new_order) { create(:completed_order_with_totals, store: new_store, number: 'K999') }

        it { expect(Spree::Order.count).not_to eq(store.orders.count) }

        it_behaves_like 'has lifetime stats'
      end
    end

    it 'can go back to the users list' do
      expect(page).to have_link Spree.t(:users), href: spree.admin_users_path
    end

    it 'can navigate to the account page' do
      expect(page).to have_link Spree.t(:"admin.user.account"), href: spree.edit_admin_user_path(user_a)
    end

    it 'can navigate to the order history' do
      expect(page).to have_link Spree.t(:"admin.user.orders"), href: spree.orders_admin_user_path(user_a)
    end

    it 'can navigate to the items purchased' do
      expect(page).to have_link Spree.t(:"admin.user.items"), href: spree.items_admin_user_path(user_a)
    end
  end

  shared_examples_for 'a sortable attribute' do
    before { click_link sort_link }

    it 'can sort asc' do
      within_table(table_id) do
        expect(page).to have_text text_match_1
        expect(page).to have_text text_match_2
        expect(text_match_1).to appear_before text_match_2
      end
    end

    it 'can sort desc' do
      within_table(table_id) do
        click_link sort_link

        expect(page).to have_text text_match_1
        expect(page).to have_text text_match_2
        expect(text_match_2).to appear_before text_match_1
      end
    end
  end

  before do
    Spree::Config[:company] = true
    create(:country)
    stub_const('Spree::User', create(:user, email: 'example@example.com').class)
    visit spree.admin_path
    click_link 'Users'
  end

  context 'users index' do
    context 'email' do
      it_behaves_like 'a sortable attribute' do
        let(:text_match_1) { user_a.email }
        let(:text_match_2) { user_b.email }
        let(:table_id) { 'listing_users' }
        let(:sort_link) { 'users_email_title' }
      end
    end

    it 'displays the correct results for a user search' do
      fill_in 'q_email_cont', with: user_a.email, visible: false
      click_button 'Search', visible: false
      within_table('listing_users') do
        expect(page).to have_text user_a.email
        expect(page).not_to have_text user_b.email
      end
    end

    context 'filtering users', js: true do
      before { visit current_path } # For Rails turbo JavaScript testing.

      it 'renders selected filters' do
        click_on 'Filter'
        wait_for { !page.has_text?('Search') }

        within('#table-filter') do
          fill_in 'q_email_cont', with: 'a@example.com'
          fill_in 'q_bill_address_firstname_cont', with: 'John'
          fill_in 'q_bill_address_lastname_cont', with: 'Doe'
          fill_in 'q_bill_address_company_cont', with: 'Company'
        end

        click_on 'Search'
        wait_for_turbo

        within('.table-active-filters') do
          expect(page).to have_content('Email: a@example.com')
          expect(page).to have_content('First Name: John')
          expect(page).to have_content('Last Name: Doe')
          expect(page).to have_content('Company: Company')
        end
      end
    end
  end

  context 'editing users' do
    before { click_link user_a.email }

    it_behaves_like 'a user page'

    it 'can edit the user email' do
      fill_in 'user_email', with: 'a@example.com99'
      click_button 'Update'

      expect(user_a.reload.email).to eq 'a@example.com99'
      expect(page).to have_text 'Account updated'
      expect(page).to have_field('user_email', with: 'a@example.com99')
    end

    it 'can edit the user password' do
      fill_in 'user_password', with: 'welcome'
      fill_in 'user_password_confirmation', with: 'welcome'
      click_button 'Update'

      expect(page).to have_text 'Account updated'
    end

    it 'can edit user roles' do
      Spree::Role.create name: 'admin'
      click_link 'Users', match: :first
      click_link user_a.email

      check 'user_spree_role_admin'
      click_button 'Update'
      expect(page).to have_text 'Account updated'
      expect(page).to have_checked_field('user_spree_role_admin')
    end

    it 'can edit user shipping address' do
      click_link 'Addresses'

      within('#admin_user_edit_addresses') do
        fill_in 'user_ship_address_attributes_address1', with: '1313 Mockingbird Ln'
        click_button 'Update'
        expect(page).to have_field('user_ship_address_attributes_address1', with: '1313 Mockingbird Ln')
      end

      expect(user_a.reload.ship_address.address1).to eq '1313 Mockingbird Ln'
      expect(user_a.ship_address.user_id).to eq user_a.id
    end

    it 'can edit user billing address' do
      click_link 'Addresses'

      within('#admin_user_edit_addresses') do
        fill_in 'user_bill_address_attributes_address1', with: '1313 Mockingbird Ln'
        click_button 'Update'
        expect(page).to have_field('user_bill_address_attributes_address1', with: '1313 Mockingbird Ln')
      end

      expect(user_a.reload.bill_address.address1).to eq '1313 Mockingbird Ln'
      expect(user_a.bill_address.user_id).to eq user_a.id
    end

    it 'can set shipping address to be the same as billing address' do
      click_link 'Addresses'

      within('#admin_user_edit_addresses') do
        find('#user_use_billing').click
        click_button 'Update'
      end

      expect(user_a.reload.ship_address == user_a.reload.bill_address).to eq true
    end
  end

  context 'order history with sorting' do
    before do
      orders
      visit spree.orders_admin_user_path(user_a)
    end

    it_behaves_like 'a user page'

    context 'completed_at' do
      it_behaves_like 'a sortable attribute' do
        let(:text_match_1) { order_time(order.completed_at) }
        let(:text_match_2) { order_time(order_2.completed_at) }
        let(:table_id) { 'listing_orders' }
        let(:sort_link) { 'orders_completed_at_title' }
      end
    end

    [:number, :state, :total].each do |attr|
      context attr do
        it_behaves_like 'a sortable attribute' do
          let(:text_match_1) { order.send(attr).to_s }
          let(:text_match_2) { order_2.send(attr).to_s }
          let(:table_id) { 'listing_orders' }
          let(:sort_link) { "orders_#{attr}_title" }
        end
      end
    end
  end

  context 'items purchased with sorting' do
    before do
      orders
      visit spree.items_admin_user_path(user_a)
    end

    it_behaves_like 'a user page'

    context 'completed_at' do
      it_behaves_like 'a sortable attribute' do
        let(:text_match_1) { order_time(order.completed_at) }
        let(:text_match_2) { order_time(order_2.completed_at) }
        let(:table_id) { 'listing_items' }
        let(:sort_link) { 'orders_completed_at_title' }
      end
    end

    [:number, :state].each do |attr|
      context attr do
        it_behaves_like 'a sortable attribute' do
          let(:text_match_1) { order.send(attr).to_s }
          let(:text_match_2) { order_2.send(attr).to_s }
          let(:table_id) { 'listing_items' }
          let(:sort_link) { "orders_#{attr}_title" }
        end
      end
    end

    it 'has item attributes' do
      items = order.line_items | order_2.line_items
      expect(page).to have_table 'listing_items'
      within_table('listing_items') do
        items.each do |item|
          expect(page).to have_selector('.item-name', text: item.product.name)
          expect(page).to have_selector('.item-price', text: item.single_money.to_html)
          expect(page).to have_selector('.item-quantity', text: item.quantity)
          expect(page).to have_selector('.item-total', text: item.money.to_html)
        end
      end
    end
  end
end
