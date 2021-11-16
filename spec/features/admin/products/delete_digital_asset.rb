require 'spec_helper'

describe 'Delete Digital Asset', type: :feature, js: true do
  stub_authorization!

  let(:product) { create(:product_with_option_types, price: '1.99', cost_price: '1.00') }

  context 'from master variant' do
    it 'removes the existing digital asset' do
      product.options.each do |option|
        create(:option_value, option_type: option.option_type)
      end

      digital = create(:digital, variant: product.master)
      visit spree.admin_product_digitals_path(product)

      expect(page).to have_content(digital.attachment.filename)
      click_link(class: 'delete-digital-asset')
      page.driver.browser.switch_to.alert.accept

      assert_admin_flash_alert_success('Digital has been successfully removed!')
    end
  end

  context 'from a regular variant' do
    it 'removes an existing digital asset' do
      variant = create(:variant, product: product, price: 19.99)
      product.options.each do |option|
        create(:option_value, option_type: option.option_type)
      end

      digital = create(:digital, variant: variant)
      visit spree.admin_product_digitals_path(product)

      expect(page).to have_content(digital.attachment.filename)
      click_link(class: 'delete-digital-asset')
      page.driver.browser.switch_to.alert.accept

      assert_admin_flash_alert_success('Digital has been successfully removed!')
    end
  end
end
