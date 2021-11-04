require 'spec_helper'

describe 'Stores', type: :feature do
  stub_authorization!

  context 'creating new store' do
    before do
      create(:zone, name: 'No Limits')

      visit spree.admin_path

      click_link 'Configurations'
      click_link 'Stores'
      within '#contentHeaderRow' do
        click_link 'New Store'
      end
    end

    after { Capybara.app_host = nil }

    it 'has required fields' do
      expect(page).to have_field(id: 'store_name')
      expect(page).to have_field(id: 'store_code')
      expect(page).to have_field(id: 'store_url')
      expect(page).to have_field(id: 'store_mail_from_address')
    end

    it 'has footer info fields' do
      expect(page).to have_field(id: 'store_description')
      expect(page).to have_field(id: 'store_address')
      expect(page).to have_field(id: 'store_contact_phone')
    end

    it 'has seo fields' do
      expect(page).to have_field(id: 'store_seo_title')
      expect(page).to have_field(id: 'store_meta_description')
      expect(page).to have_field(id: 'store_meta_keywords')
      expect(page).to have_field(id: 'store_seo_robots')
    end

    it 'creates a new store' do
      fill_in 'Name', with: 'Store name'
      fill_in 'Code', with: 'example_store'
      fill_in 'URL', with: 'http://another-store.lvh.me'
      fill_in 'Mail from address', with: 'store@example.com'

      click_button 'Create'

      Capybara.app_host = 'http://another-store.lvh.me'

      expect(page).to have_content('http://another-store.lvh.me')
      expect(page).to have_content('example_store')
      expect(page).to have_content('Stores')
    end

    it 'creates a new store with footer and seo data' do
      fill_in 'Name', with: 'Store name'
      fill_in 'Code', with: 'example_store'
      fill_in 'URL', with: 'http://one-another-store.lvh.me'
      fill_in 'Mail from address', with: 'store@example.com'
      fill_in 'Description', with: 'New store description'
      fill_in 'Address', with: 'New store address 123, City 123'
      fill_in 'Contact phone', with: '123123123'
      fill_in 'Customer Support Email', with: 'contact@example.com'
      fill_in 'SEO Title', with: 'Spree Store meta title'
      fill_in 'Meta Description', with: 'Spree Store meta description'
      fill_in 'Meta Keywords', with: 'Spree, Store'
      fill_in 'SEO Robots', with: 'noindex'

      click_button 'Create'

      Capybara.app_host = 'http://one-another-store.lvh.me'

      expect(page).to have_content('http://one-another-store.lvh.me')
      expect(page).to have_content('Stores')
    end
  end

  context 'editing existing store', js: true do
    let!(:updated_zone) { create(:zone, name: 'EU_VAT') }

    before do
      @zone = create(:zone, name: 'No Limits')
      create(:store, name: 'Some existing store', checkout_zone_id: @zone.id)

      visit spree.admin_path

      click_link 'Configurations'
      click_link 'Stores'
    end

    it 'edits existing store' do
      within_row(1) { click_icon :edit }
      fill_in 'Mail from address', with: 'new_email@example.com'
      click_button 'Update'

      expect(page).to have_content('successfully updated!')
    end

    it 'edits existing stores footer info' do
      within_row(1) { click_icon :edit }
      fill_in 'Description', with: 'Some edited description'
      click_button 'Update'

      expect(page).to have_content('successfully updated!')
    end
  end

  context 'with checkout_zone_id attribute set for store', js: true do
    let!(:store) { create(:store, name: 'Some existing store', checkout_zone_id: zone.id) }
    let!(:zone) { create(:zone, name: 'Asia') }

    before do
      visit spree.admin_path

      click_link 'Configurations'
      click_link 'Stores'
    end

    it 'edits existing store' do
      within_row(1) { click_icon :edit }
      fill_in 'Mail from address', with: 'some_email@example.com'
      click_button 'Update'

      expect(page).to have_content('successfully updated!')
    end
  end
end
