require 'spec_helper'

describe 'Product Taxons', type: :feature, js: true do
  stub_authorization!

  context 'managing taxons' do
    it 'allows an admin to manage taxons' do
      store = Spree::Store.default
      taxonomy = create(:taxonomy, store: store, name: 'Categories')
      taxon_1 = create(:taxon, taxonomy: taxonomy)
      taxon_2 = create(:taxon, name: 'Clothing', taxonomy: taxonomy)
      product = create(:product, stores: [store])
      product.taxons << taxon_1
      visit spree.admin_product_path(product)

      expect(page).to have_css('.select2-selection__choice', text: "#{taxon_1.parent.name} -> #{taxon_1.name}")

      select2_open label: 'Taxons'
      select2_search 'Clothing', from: 'Taxons'
      select2_select 'Categories -> Clothing', from: 'Taxons', match: :first

      click_button 'Update'

      expect(page).to have_css('.select2-selection__choice', text: taxon_1.name).
        and have_css('.select2-selection__choice', text: taxon_2.name)
    end
  end
end
