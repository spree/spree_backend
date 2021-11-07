require 'spec_helper'

describe 'Admin store switcher', type: :feature, js: true do
  stub_authorization!

  let!(:admin_user) { create(:admin_user) }
  let!(:store_one) { Spree::Store.default }
  let!(:store_two) { create(:store, url: 'www.example-one.com') }
  let!(:store_three) { create(:store, url: 'www.example-two.com') }

  context 'on the orders page of admin' do
    before do
      visit spree.admin_path
    end

    it 'allows to change the url to the selected store and returns you to orders page' do
      find('a#storeSelectorDropdown').click

      expect(page).to have_selector(:css, "a[href*='#{spree.admin_switch_store_path(store_one.id)}']")
      expect(page).to have_selector(:css, "a[href*='#{spree.admin_switch_store_path(store_two.id)}']")
      expect(page).to have_selector(:css, "a[href*='#{spree.admin_switch_store_path(store_three.id)}']")
    end
  end

  context 'can add new store using + Add New Store link' do
    before do
      visit spree.admin_path
    end

    it 'displays the link in the store selector dropdown' do
      find('a#storeSelectorDropdown').click
      expect(page).to have_selector(:css, "a[href*='#{spree.new_admin_store_path(@user)}']")
    end

    it 'takes you to the add new store page when clicked' do
      expect(page).not_to have_text('Stores / New Store')

      find('a#storeSelectorDropdown').click
      find('a#addNewStoreLink').click

      expect(page).to have_text('Stores / New Store')
    end
  end
end
