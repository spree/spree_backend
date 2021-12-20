require 'spec_helper'

describe 'Stores admin', type: :feature do
  stub_authorization!

  let(:store) { Spree::Store.default }
  let(:zone) { create(:zone, name: 'EU_VAT') }
  let!(:no_limits) { create(:zone, name: 'No Limits') }

  before { store.update!(checkout_zone: zone) }

  describe 'creating store' do
    it 'sets default currency value', js: true do
      visit spree.new_admin_store_path
      expect(page).to have_selector(:id, 'select2-store_default_currency-container', text: 'United States Dollar (USD)')
    end

    it 'saving store' do
      visit spree.new_admin_store_path
      page.fill_in 'store_name', with: 'Spree Example Test'
      page.fill_in 'store_url', with: 'test.localhost'
      page.fill_in 'store_code', with: 'spree'
      page.fill_in 'store_mail_from_address', with: 'no-reply@example.com'
      select 'EUR', from: 'Default currency'
      select 'GBP', from: 'Supported Currencies'
      unselect 'USD', from: 'Supported Currencies'
      select 'GBP', from: 'Supported Currencies'

      select 'English (US)', from: 'Default locale'

      click_button 'Create'

      expect(page).to have_current_path spree.admin_orders_path
      expect(page).to have_content('Spree Example Test (spree)')
      expect(Spree::Store.count).to eq 2
      store = Spree::Store.last
      expect(store.name).to eq 'Spree Example Test'
      expect(store.default_currency).to eq 'EUR'
      expect(store.supported_currencies_list.map(&:iso_code)).to contain_exactly('EUR', 'GBP')
      expect(store.default_locale).to eq 'en'
    end
  end

  describe 'updating store', js: true do
    it do
      visit spree.edit_admin_store_path(store)
      page.fill_in 'store_name', with: '', wait: 5
      page.fill_in 'store_name', with: 'New Store Name', wait: 5
      select2 'EUR', from: 'Default currency'
      click_button 'Update'

      expect(page).to have_content('successfully updated')

      store.reload
      expect(store.default_currency).to eq 'EUR'
      expect(store.name).to eq 'New Store Name'
    end

    describe 'uploading a favicon' do
      let(:favicon) { file_fixture('favicon.ico') }

      before do
        visit spree.edit_admin_store_path(store)

        attach_file('Favicon', favicon)

        click_on 'Update'
      end

      it 'allows uploading a favicon' do
        expect(page).to have_content('Store "Spree Test Store" has been successfully updated!')
        expect(store.reload.favicon_image.attached?).to be(true)
      end

      context 'when a favicon is invalid' do
        let(:favicon) { file_fixture('icon_512x512.png') }

        it 'prevents uploading a favicon and displays an error message' do
          expect(page).to have_content('Unable to update store.: Favicon image must be less than or equal to 256 x 256 pixel')
          expect(store.reload.favicon_image.attached?).to be(false) if Rails.version.to_f > 5.2
        end
      end
    end
  end

  describe 'deleting store', js: true do
    let!(:second_store) { create(:store, url: 'another-store.lvh.me', code: 'another-store') }

    before { Capybara.app_host = second_store.formatted_url }

    after { Capybara.app_host = nil }

    it 'deletes store' do
      visit spree.edit_admin_store_url(second_store, host: second_store.formatted_url)

      accept_confirm do
        page.find('.icon-delete').click
      end
      expect(page).to have_current_path(spree.admin_path)

      expect(second_store.reload).to be_deleted
    end
  end
end
