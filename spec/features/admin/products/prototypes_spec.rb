require 'spec_helper'

describe 'Prototypes', type: :feature, js: true do
  stub_authorization!

  context 'listing prototypes' do
    it 'is able to list existing prototypes' do
      create(:property, name: 'model', presentation: 'Model')
      create(:property, name: 'brand', presentation: 'Brand')
      create(:property, name: 'shirt_fabric', presentation: 'Fabric')
      create(:property, name: 'shirt_sleeve_length', presentation: 'Sleeve')
      create(:property, name: 'mug_type', presentation: 'Type')
      create(:property, name: 'bag_type', presentation: 'Type')
      create(:property, name: 'manufacturer', presentation: 'Manufacturer')
      create(:property, name: 'bag_size', presentation: 'Size')
      create(:property, name: 'mug_size', presentation: 'Size')
      create(:property, name: 'gender', presentation: 'Gender')
      create(:property, name: 'shirt_fit', presentation: 'Fit')
      create(:property, name: 'bag_material', presentation: 'Material')
      create(:property, name: 'shirt_type', presentation: 'Type')
      p = create(:prototype, name: 'Shirt')
      %w(brand gender manufacturer model shirt_fabric shirt_fit shirt_sleeve_length shirt_type).each do |prop|
        p.properties << Spree::Property.find_by(name: prop)
      end
      p = create(:prototype, name: 'Mug')
      %w(mug_size mug_type).each do |prop|
        p.properties << Spree::Property.find_by(name: prop)
      end
      p = create(:prototype, name: 'Bag')
      %w(bag_type bag_material).each do |prop|
        p.properties << Spree::Property.find_by(name: prop)
      end

      visit spree.admin_path
      click_link 'Products'
      click_link 'Prototypes'

      within_row(1) { expect(column_text(1)).to eq 'Shirt' }
      within_row(2) { expect(column_text(1)).to eq 'Mug' }
      within_row(3) { expect(column_text(1)).to eq 'Bag' }
    end
  end

  context 'creating a prototype' do
    it 'allows an admin to create a new product prototype' do
      visit spree.admin_path
      click_link 'Products'
      click_link 'Prototypes'

      click_link 'new_prototype_link'
      within('.content-header') do
        expect(page).to have_content('New Prototype')
      end
      fill_in 'prototype_name', with: 'male shirts'
      click_button 'Create'
      expect(page).to have_content('successfully created!')

      visit spree.admin_prototypes_path
      within_row(1) { click_icon :edit }
      fill_in 'prototype_name', with: 'Shirt 99'
      click_button 'Update'
      expect(page).to have_content('successfully updated!')
      expect(page).to have_content('Shirt 99')
    end

    context 'selecting taxons' do
      let(:prototype_name) { 'shirts' }
      let!(:store1) { Spree::Store.default }
      let!(:taxonomy1) { create(:taxonomy, name: 'Shirts', store: store1) }
      let!(:store2) { create(:store) }
      let!(:taxonomy2) { create(:taxonomy, name: 'Bags', store: store2) }

      it 'should be able to select only current store taxons' do
        visit spree.admin_path
        click_link 'Products'
        click_link 'Prototypes'

        click_link 'new_prototype_link'
        within('.content-header') do
          expect(page).to have_content('New Prototype')
        end
        fill_in 'prototype_name', with: prototype_name

        select2_open label: 'Taxons'
        expect(page).to have_content('Shirts')
        expect(page).not_to have_content('Bags')
        select2_select 'Shirts', from: 'Taxons'

        click_button 'Create'

        expect(page).to have_content('successfully created!')
        expect(Spree::Prototype.find_by(name: prototype_name).taxons).to match_array([taxonomy1.root])
      end
    end
  end

  context 'editing a prototype' do
    it 'allows to empty its properties' do
      model_property = create(:property, name: 'model', presentation: 'Model')
      brand_property = create(:property, name: 'brand', presentation: 'Brand')

      shirt_prototype = create(:prototype, name: 'Shirt', properties: [])
      %w(brand model).each do |prop|
        shirt_prototype.properties << Spree::Property.find_by(name: prop)
      end

      visit spree.admin_path
      click_link 'Products'
      click_link 'Prototypes'

      click_icon :edit

      first('span[class="select2-selection__choice__remove"]').click
      find('span[class="select2-selection__choice__remove"]').click

      click_button 'Update'

      click_icon :edit
      expect(page).to have_no_css('.select2-search-choice')
    end
  end

  it 'is deletable' do
    shirt_prototype = create(:prototype, name: 'Shirt', properties: [])
    shirt_prototype.taxons << create(:taxon)

    visit spree.admin_path
    click_link 'Products'
    click_link 'Prototypes'

    expect(page).to have_content('Shirt')

    accept_confirm do
      within("#spree_prototype_#{shirt_prototype.id}") do
        page.find('.delete-resource').click
      end
    end
    expect(page).to have_content("Prototype \"#{shirt_prototype.name}\" has been successfully removed!")
  end
end
