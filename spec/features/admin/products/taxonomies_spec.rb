require 'spec_helper'

describe 'Taxonomies', type: :feature, js: true do
  stub_authorization!

  before do
    visit spree.admin_path
    click_link 'Products'
  end

  context 'show' do
    it 'displays existing taxonomies' do
      create(:taxonomy, name: 'Brand')
      create(:taxonomy, name: 'Categories')
      visit spree.admin_taxonomies_path
      within_row(1) { expect(page).to have_content('Brand') }
      within_row(2) { expect(page).to have_content('Categories') }
    end
  end

  context 'create' do
    before do
      click_link 'Taxonomies'
      click_link 'admin_new_taxonomy_link'
    end

    it 'allows an admin to create a new taxonomy' do
      expect(page).to have_content('New Taxonomy')

      fill_in 'taxonomy_name', with: 'sports'
      click_button 'Create'
      wait_for_turbo

      expect(page).to have_content('sports has no Taxons. Click the Add a new Taxon button, to begin adding Taxons.')
      expect(page).to have_content('successfully created!')
    end

    it 'displays validation errors' do
      fill_in 'taxonomy_name', with: ''
      click_button 'Create'

      message = page.find('[name="taxonomy[name]"]').native.attribute("validationMessage")
      expect(message).to have_content "Please fill"
    end
  end

  context 'edit' do
    it 'allows an admin to update an existing taxonomy through root taxon' do
      tx = create(:taxonomy)
      click_link 'Taxonomies'
      within_row(1) { click_icon :edit }
      click_link Spree.t('admin.taxonomies.edit_root_taxonomy', name: tx.name )

      expect(page).not_to (have_selector 'select2-hidden-accessible')

      fill_in 'taxon_name', with: 'sports 99', fill_options: { clear: :backspace }
      click_button 'Update'

      expect(page).to have_content('Taxon "sports 99" has been successfully updated!')
      expect(page).to have_content('sports 99')

      within '#contentHeaderRow' do
        click_link 'Taxonomies'
      end


      expect(page).to have_content('sports 99')
    end
  end
end
