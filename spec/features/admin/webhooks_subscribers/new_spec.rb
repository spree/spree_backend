require 'spec_helper'

describe 'Webhooks::Subscriber#new', type: :feature do
  stub_authorization!

  context 'creating a new subscriber' do
    it 'coming from #index' do
      visit spree.admin_webhooks_subscribers_path
      within('div#contentHeader') do
        click_on 'New Webhooks Subscriber'
      end

      within('h1') do
        expect(page).to have_text 'New Webhooks Subscriber'
      end
      expect(page).to have_field(id: 'webhooks_subscriber_url', disabled: false)
      expect(page).to have_field(id: 'webhooks_subscriber_active', disabled: false)
      expect(page).to have_field(id: 'subscribe-to-all', disabled: false)
      expect(page).to have_field(name: 'webhooks_subscriber[subscriptions][]')
    end

    it 'submitting with Subscribe To All Events' do
      visit spree.new_admin_webhooks_subscriber_path

      fill_in 'webhooks_subscriber_url', with: 'https://imgur.com/path'
      check 'webhooks_subscriber_active'
      choose 'subscribe-to-all'

      click_on 'Create'

      expect(page).to have_current_path('/admin/webhooks_subscribers')
      expect(page).to have_content 'created'

      within_row(1) { expect(page).to have_content('*') }
      within_row(1) { expect(page).to have_content('https://imgur.com/path') }
    end

    it 'submitting with Subscribe To Selected Events' do
      visit spree.new_admin_webhooks_subscriber_path

      fill_in 'webhooks_subscriber_url', with: 'https://imgur.com/path'
      check 'webhooks_subscriber_active'
      choose 'subscribe_to_all_events_false'

      check 'webhooks_subscriber_subscriptions_address_createaddress_deleteaddress_update'
      check 'webhooks_subscriber_subscriptions_digital_createdigital_deletedigital_update'

      click_on 'Create'

      expect(page).to have_current_path('/admin/webhooks_subscribers')
      expect(page).to have_content 'created'

      within_row(1) { expect(page).to have_content('address.create, address.delete, address.update, digital.create, digital.delete, digital.update') }
      within_row(1) { expect(page).to have_content('https://imgur.com/path') }
    end
  end
end

