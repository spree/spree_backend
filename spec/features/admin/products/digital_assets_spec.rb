require 'spec_helper'

describe 'Add New Digital Asset', type: :feature, js: true do
  stub_authorization!

  let(:product) { create(:product_with_option_types, price: '1.99', cost_price: '1.00') }

  context 'to product without variants' do
    before do
      product.options.each do |option|
        create(:option_value, option_type: option.option_type)
      end
    end

    context 'without added digital' do
      it 'displays no digitals' do
        visit spree.admin_product_digitals_path(product)

        expect(page).to have_content(Spree.t('admin.digitals.no_digital_assets_added'), count: 1)
      end
    end

    context 'with added digital' do
      it 'displays the digital asset for the master variant' do
        digital = create(:digital, variant: product.master)
        visit spree.admin_product_digitals_path(product)

        expect(page).to have_content(digital.attachment.filename)
        expect(page).not_to have_content(Spree.t('admin.digitals.no_digital_assets_added'))
      end
    end
  end

  context 'to product with variant' do
    before do
      create(:variant, product: product, price: 19.99)

      product.options.each do |option|
        create(:option_value, option_type: option.option_type)
      end
    end

    context 'without added digital' do
      it 'show no digital assets message' do
        visit spree.admin_product_digitals_path(product)

        expect(page).to have_content(Spree.t('admin.digitals.no_digital_assets_added'))
      end
    end

    context 'with added digital' do
      it 'displays the digital assets' do
        master_digital = create(:digital, variant: product.master)
        variant_digital = create(:digital, variant: create(:variant, product: product, price: 19.99))

        visit spree.admin_product_digitals_path(product)

        expect(page).to have_content(master_digital.attachment.filename)
        expect(page).to have_content(variant_digital.attachment.filename)
        expect(page).not_to have_content(Spree.t(:add_new_file, scope: 'digitals'))
      end
    end
  end

  context 'without selected attachment' do
    it 'disables the upload button' do
      visit spree.admin_product_digitals_path(product)

      expect(page).to have_button('Upload', disabled: true)
    end
  end
end
