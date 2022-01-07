require 'spec_helper'

describe 'Order Internal Note', type: :feature do
  stub_authorization!

  before do
    visit spree.new_admin_order_path
  end

  context 'navigating to Notes via the tab' do
    it 'loads Order notes form and saves notes' do
      within find('[data-hook="admin_order_tabs"]') do
        click_link 'Internal Notes'
      end

      fill_in 'Notes', with: 'This order is not to be shipped until customer confirms with Jeff.'

      click_button 'Update'

      wait_for_turbo

      expect(page).to have_text('This order is not to be shipped until customer confirms with Jeff.')
    end
  end
end
