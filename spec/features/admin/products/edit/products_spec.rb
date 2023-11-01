require 'spec_helper'

describe 'Product Details', type: :feature, js: true do
  stub_authorization!

  let!(:product) { create(:product, name: 'Bún thịt nướng', sku: 'A100', description: 'lorem ipsum') }

  context 'editing a product with WYSIWYG disabled' do
    before do
      Spree::Backend::Config.product_wysiwyg_editor_enabled = false
      visit spree.admin_product_path(product)
    end

    after { Spree::Backend::Config.product_wysiwyg_editor_enabled = true }

    it 'displays the product description as a standard input field' do
      expect(page).to have_field(id: 'product_description', with: product.description)
      expect(page).not_to have_css('#product_description_ifr')
    end
  end

  context 'editing a product with WYSIWYG editor enabled' do
    before do
      Spree::Backend::Config.product_wysiwyg_editor_enabled = true
      visit spree.admin_product_path(product)
    end

    it 'displays the product details with a WYSIWYG editor for the product description input' do
      expect(page).to have_css('.content-header', text: 'Bún thịt nướng')
      expect(page).to have_field(id: 'product_name', with: 'Bún thịt nướng')
      expect(page).to have_field(id: 'product_slug', with: 'bun-th-t-n-ng')
      expect(page).not_to have_field(id: 'product_description')
      expect(page).to have_css('#product_description_ifr')
      expect(page).to have_field(id: 'product_price', with: '19.99')
      expect(page).to have_field(id: 'product_cost_price', with: '17.00')
      expect(page).to have_field(id: 'product_sku', with: 'A100')
    end

    it 'shows product description using wysiwyg editor' do
      expect(page).not_to have_field(id: 'product_description', with: 'lorem ipsum')
      expect(page).to have_css('#product_description_ifr')
    end

    it 'handles slug changes' do
      fill_in 'product_slug', with: 'random-slug-value'
      click_button 'Update'
      expect(page).to have_content('successfully updated!')
    end
  end

  describe 'status related fields behavior' do
    before do
      visit spree.admin_product_path(product)
    end

    it 'hides make available_on' do
      expect(page).to have_field(id: 'product_status', with: 'active')
      expect(page).to have_content('Available On')
      expect(page).not_to have_content('Make Active At')
      expect(page).to have_content('Discontinue On')
    end

    it 'hides discontinue_on' do
      select 'draft', from: 'Status'
      expect(page).to have_content('Available On')
      expect(page).to have_content('Make Active At')
      expect(page).to have_content('Discontinue On')
    end

    it 'hides all fields', js: true do
      select 'archived', from: 'Status'
      click_button 'Update'
      expect(page).not_to have_content('Available On')
      expect(page).not_to have_content('Make Active At')
      expect(page).to have_content('Discontinue On')
    end
  end
end
