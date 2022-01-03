require 'spec_helper'

describe 'Store Wide Search', type: :feature, js: true do
  stub_authorization!

  let!(:store) { Spree::Store.default }
  let!(:product) { create(:product, name: 'spree t-shirt', price: 20.00, stores: [store]) }
  let!(:order) { create(:order, state: 'complete', completed_at: '2011-02-01 12:36:15', number: 'R02487872', store: store) }
  let!(:cms_page) { create(:cms_standard_page, store: store, title: 'About Us') }
  let!(:taxonomy) { create(:taxonomy, name: 'clothing') }
  let!(:taxon_a) { create(:taxon, taxonomy: taxonomy, name: 'Trousers') }

  before { visit spree.admin_path }

  context 'searching orders' do
    it 'finds the order by number and redirects to the order edit page' do
      fill_in 'storeSearch', with: 'R02487872'

      wait_for_turbo
      find('#autoComplete_result_0').click
      wait_for_turbo
      expect(page).to have_selector('h4', text: 'R02487872')
    end

    it 'finds the order by email and redirects to the order edit page' do
      fill_in 'storeSearch', with: order.email

      wait_for_turbo
      find('#autoComplete_result_1').click
      wait_for_turbo
      expect(page).to have_selector('h4', text: 'R02487872')
    end
  end

  context 'searching for a user' do
    it 'finds the user by email and redirects to the user edit page' do
      fill_in 'storeSearch', with: order.email

      wait_for_turbo
      find('#autoComplete_result_0').click
      wait_for_turbo
      expect(page).to have_selector('h4', text: order.email)
    end
  end

  context 'searching for a cms_page' do
    it 'finds the cms_page by title and redirects to the edit cms_page' do
      fill_in 'storeSearch', with: 'About'

      wait_for_turbo
      find('#autoComplete_result_0').click
      wait_for_turbo
      expect(page).to have_selector('h4', text: 'All Pages / About Us')
    end
  end

  context 'searching for a product' do
    it 'finds the product by name and redirects to the product edit page' do
      fill_in 'storeSearch', with: product.name

      wait_for_turbo
      find('#autoComplete_result_0').click
      wait_for_turbo
      expect(page).to have_selector('h4', text: product.name)
    end

    it 'finds the product by SKU and redirects to the product edit page' do
      fill_in 'storeSearch', with: product.sku

      wait_for_turbo
      find('#autoComplete_result_0').click
      wait_for_turbo
      expect(page).to have_selector('h4', text: product.name)
    end
  end

  context 'searching for a taxon' do
    it 'finds the taxon by name and redirects to the taxon edit page' do
      fill_in 'storeSearch', with: 'Trousers'

      wait_for_turbo
      find('#autoComplete_result_0').click
      wait_for_turbo
      expect(page).to have_selector('h4', text: 'Taxonomies / clothing / Trousers')
    end
  end
end
