require 'spec_helper'

describe 'Edit Standard Page', type: :feature do
  stub_authorization!

  context 'when a user creates a Standard Page' do
    let!(:store_sp) { create(:store, default: true, name: 'Super Store', supported_locales: 'en,fr') }

    before do
      visit spree.new_admin_cms_page_path
      I18n.backend.store_translations(:fr,
                                      spree: {
                                        i18n: {
                                          this_file_language: 'Français (FR)'
                                        }
                                      })

      fill_in 'Title *', with: 'Privacy Policy'
      fill_in 'Meta Title', with: 'Meta-T-Content'
      fill_in 'Meta Description', with: 'Meta-Description-Content'

      click_on 'Create'
    end

    it 'saves the basic setting fields and generates a slug' do
      expect(page).to have_field('Title *', with: 'Privacy Policy')
      expect(page).to have_field('Slug', with: 'privacy-policy')
      expect(page).to have_field('Meta Title', with: 'Meta-T-Content')
      expect(page).to have_text ('Meta-Description-Content')
    end

    it 'slug should not be disabled' do
      expect(page).to have_field('Slug', disabled: false)
    end

    it 'loads the RTE', js: true do
      expect(page).to have_css '.tox-editor-container'
    end

    it 'displays the language of the page' do
      expect(page).to have_text ('English (US)')
    end

    it 'allows user to switch language', js: true do
      find('[aria-controls="collapsePageSettings"]').click

      find('[name="cms_page[locale]"]').find(:option, 'Français (FR)').select_option

      click_on 'Update'
      wait_for_turbo

      expect(page).to have_text('Français (FR)')
    end

    it 'allows user to toggle visibility', js: true do
      expect(page).to have_text ('Visible')

      find(:xpath, '//*[@id="cms_page_visible"]/..').click
      click_button 'Update'
      wait_for_turbo
      expect(page).to have_text ('Draft Mode')
    end

    it 'allows user to toggle more page settings enter data and save', js: true do
      find('[aria-controls="collapsePageSettings"]').click
      fill_in 'Meta Description', with: 'M-Description'

      click_on 'Update'
      wait_for_turbo

      find('[aria-controls="collapsePageSettings"]').click
      expect(page).to have_text ('M-Description')
    end
  end
end
