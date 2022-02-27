require 'spec_helper'

describe 'Order / Internal Note', type: :feature do
  stub_authorization!

  before do
    visit spree.new_admin_order_path
  end

  context 'from an order page', js: true do
    it 'allows admin user to create and save a new note' do
      within '#order_notes_summary' do
        click_icon 'order-note-edit'
      end

      wait_for_turbo

      expect(page).to have_field('internal_note')
      expect(page).to have_css('.icon-close-order-note-edit')
      expect(page).not_to have_css('.icon-order-note-edit')
      fill_in 'internal_note', with: 'This order is not to be shipped until customer confirms with Jeff.'

      click_button 'Update'

      wait_for_turbo

      expect(page).to have_css('.icon-order-note-edit')
      expect(page).not_to have_field('internal_note')
      expect(page).to have_text('This order is not to be shipped until customer confirms with Jeff.')
    end
  end
end
