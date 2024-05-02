require 'spec_helper'

describe 'New Menu', type: :feature do
  stub_authorization!

  context 'when a user tries to create a menu with no name' do
    before do
      visit spree.new_admin_menu_path
    end

    it "warns that the Name can't be blank" do
      click_on 'Create'
      expect(page).to have_text ("Name can't be blank")
    end
  end

  context 'when a user tries to create a menu with a duplicate location within scope of stores and language', js: true do
    let!(:main_menu) { create(:menu, name: 'Main Menu') }

    before do
      visit spree.new_admin_menu_path
    end

    it 'warns the user that the location has already been taken' do
      fill_in 'Name', with: 'Main Menu'

      select2 'Header', from: 'Location'
      click_on 'Create'
      expect(page).to have_text ('Location has already been taken')
    end
  end

  context 'user can create a new menu', js: true do
    before do
      visit spree.new_admin_menu_path
    end

    it 'with stores' do
      fill_in 'Name', with: 'Main Menu'

      select2 'Footer', from: 'Location'
      click_on 'Create'

      assert_admin_flash_alert_success('Menu "Main Menu" has been successfully created!')
      expect(page).to have_text 'Main Menu has no items. Click the Add New Item button to begin adding links to this menu.'
      expect(page).to have_selector('a', text: Spree.t('admin.navigation.add_new_item'))

      # Tests that root name is in sync with menu name.
      fill_in 'Name', with: 'X14dP'
      click_on 'Update'
      expect(page).to have_text 'X14dP has no items. Click the Add New Item button to begin adding links to this menu.'
    end
  end
end
