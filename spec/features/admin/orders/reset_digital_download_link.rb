require 'spec_helper'

describe 'Reset Digital Download Link', type: :feature, js: true do
  stub_authorization!

  let(:order)     { create(:completed_order_with_totals, number: 'R100', line_items_count: 1) }
  let(:line_item) { order.line_items.first }
  let(:variant)   { line_item.variant }

  context 'when order contains digital line items' do
    let!(:digital) { create(:digital, variant: variant) }

    it 'displays the reset digital download links button and it can be clicked' do
      visit spree.edit_admin_order_path(order)

      within('#contentHeaderRow') do
        click_link Spree.t('admin.digitals.reset_download_links')
      end

      assert_admin_flash_alert_notice(Spree.t('admin.digitals.downloads_reset'))
    end
  end

  context 'when order contains no digital line items' do
    it 'does not display the reset digital download links button' do
      visit spree.edit_admin_order_path(order)

      expect(page).not_to have_content(Spree.t('admin.digitals.reset_download_links'))
    end
  end
end
