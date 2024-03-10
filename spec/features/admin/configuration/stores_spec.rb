require 'spec_helper'

describe 'Stores admin', type: :feature do
  stub_authorization!

  let(:store) { Spree::Store.default }
  let(:zone) { create(:zone, name: 'EU_VAT') }
  let!(:no_limits) { create(:zone, name: 'No Limits') }

  before { store.update!(checkout_zone: zone) }

  describe 'creating store' do
    context 'setting default values', js: true do
      it 'sets default currency value' do
        visit spree.new_admin_store_path
        expect(page).to have_selector(:id, 'select2-store_default_currency-container', text: 'United States Dollar (USD)')
      end

      it 'sets default checkout zone' do
        visit spree.new_admin_store_path
        expect(page).to have_field('store_checkout_zone_id', text: 'No Limits')
      end

      context 'default country' do
        let!(:default_country) { create(:country) }

        context 'when default store has default_country_id' do
          before do
            Spree::Store.default.update(default_country_id: default_country.id)
            visit spree.new_admin_store_path
          end

          it 'sets default country of new Store to the default store\'s default country' do
            expect(page).to have_field('store_default_country_id', text: default_country.to_s)
          end
        end

        context 'when default store does not have default_country_id' do
          before do
            Spree::Store.default.update(default_country_id: nil)
            visit spree.new_admin_store_path
          end

          it 'sets default country of new Store to the default store\'s default country' do
            expect(page).to have_field('store_default_country_id', text: 'United States')
          end
        end
      end
    end

    it 'saving store' do
      visit spree.new_admin_store_path
      page.fill_in 'store_name', with: 'Spree Example Test'
      page.fill_in 'store_url', with: 'test.localhost'
      page.fill_in 'store_code', with: 'spree'
      page.fill_in 'store_mail_from_address', with: 'no-reply@example.com'
      select 'EUR', from: 'Default currency'
      select 'GBP', from: 'Supported Currencies'
      unselect 'USD', from: 'Supported Currencies', match: :first
      select 'GBP', from: 'Supported Currencies'

      select 'English (US)', from: 'Default locale'

      click_button 'Create'

      expect(page).to have_current_path spree.admin_path
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
  end

  describe 'deleting store', js: true do
    let!(:second_store) { create(:store, url: 'another-store.lvh.me') }

    before { Capybara.app_host = second_store.formatted_url }

    after { Capybara.app_host = nil }

    it 'deletes store' do
      visit spree.edit_admin_store_path(second_store)

      accept_confirm do
        page.find('.icon-delete').click
      end
      expect(page).to have_current_path(spree.admin_path)

      expect(Spree::Store.find_by_id(second_store.id)).to be_nil
    end
  end
end
