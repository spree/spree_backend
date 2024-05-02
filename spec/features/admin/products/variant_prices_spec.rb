require 'spec_helper'

describe 'Variant Prices', type: :feature, js: true do
  stub_authorization!
  let(:store) { Spree::Store.default }
  let!(:store2) { create(:store, default: false, default_currency: 'GBP') }

  before do
    store.update(supported_currencies: 'USD,EUR')
  end

  let!(:product) { create(:product, stores: Spree::Store.all) }

  context 'with USD and EUR as currencies' do
    it 'allows to save a price for each currency' do
      visit spree.admin_product_path(product)
      click_link 'Prices'
      expect(page).to have_content 'USD'
      expect(page).to have_content 'EUR'
      expect(page).to have_content 'GBP'

      fill_in "vp_#{product.master.id}_USD_price", with: '29.95', fill_options: { clear: :backspace }
      fill_in "vp_#{product.master.id}_EUR_price", with: '21.94', fill_options: { clear: :backspace }
      fill_in "vp_#{product.master.id}_GBP_price", with: '19.94', fill_options: { clear: :backspace }

      click_button 'Update'
      wait_for_turbo
      # expect(page).to have_content 'Prices successfully saved'
      product.reload
      expect(product.master.price_in('USD').amount).to eq(29.95)
      expect(product.master.price_in('EUR').amount).to eq(21.94)
      expect(product.master.price_in('GBP').amount).to eq(19.94)
    end

    it 'allows to save a compare to price for each currency' do
      visit spree.admin_product_path(product)
      click_link 'Prices'
      expect(page).to have_content 'Compare at price'

      fill_in "vp_#{product.master.id}_USD_price", with: '29.95', fill_options: { clear: :backspace }
      fill_in "vp_#{product.master.id}_EUR_price", with: '21.94', fill_options: { clear: :backspace }
      fill_in "vp_#{product.master.id}_GBP_price", with: '19.94', fill_options: { clear: :backspace }

      fill_in "vp_#{product.master.id}_USD_compare_at_price", with: '59.95', fill_options: { clear: :backspace }
      fill_in "vp_#{product.master.id}_EUR_compare_at_price", with: '51.94', fill_options: { clear: :backspace }
      fill_in "vp_#{product.master.id}_GBP_compare_at_price", with: '49.94', fill_options: { clear: :backspace }

      click_button 'Update'
      wait_for_turbo
      # expect(page).to have_content 'Prices successfully saved'
      product.reload
      expect(product.master.price_in('USD').compare_at_amount).to eq(59.95)
      expect(product.master.price_in('EUR').compare_at_amount).to eq(51.94)
      expect(product.master.price_in('GBP').compare_at_amount).to eq(49.94)
    end
  end
end
