require 'spec_helper'

describe 'Webhooks::Subscriber#edit', type: :feature do
  stub_authorization!

  before { visit spree.edit_admin_webhooks_subscriber_path(subscriber) }

  context 'when subscribed to all events' do
    let!(:subscriber) { create(:webhook_subscriber, :active, subscriptions: ['*']) }

    it 'has the correct values populated in the fields' do
      within('h1') do
        expect(page).to have_text subscriber.url
      end

      expect(page).to have_field(id: 'webhooks_subscriber_url', with: subscriber.url)
      expect(page).to have_field(id: 'webhooks_subscriber_active', checked: true)
      expect(page).to have_field(id: 'subscribe-to-all', checked: true)
    end

    it 'updates the subscriber successfully' do
      fill_in 'webhooks_subscriber_url', with: 'https://facebook.com/path'
      uncheck 'webhooks_subscriber_active'
      choose 'subscribe_to_all_events_false'
      check 'webhooks_subscriber_subscriptions_address_createaddress_updateaddress_delete'
      check 'webhooks_subscriber_subscriptions_line_item_createline_item_updateline_item_delete'

      click_on 'Update'

      expect(page).to have_content('successfully updated')
      within_row(1) { expect(page).to have_content('https://facebook.com/path') }
      within_row(1) { expect(page).to have_content(Spree.t(:inactive)) }
      within_row(1) { expect(page).to have_content('address.create, address.update, address.delete') }
      within_row(1) { expect(page).to have_content('line_item.create, line_item.update, line_item.delete') }
    end
  end

  context 'when subscribed to some events', js: true do
    let(:subscriptions) do
      %w[credit_card.create credit_card.update credit_card.delete
         customer_return.create customer_return.update customer_return.delete]
    end
    let!(:subscriber) { create(:webhook_subscriber, :active, subscriptions: subscriptions) }

    it 'selects the correct checkboxes' do
      expect(page).to have_field(id: 'subscribe_to_all_events_false', checked: true)
      expect(page).to have_field(name: 'webhooks_subscriber[subscriptions][]', checked: true, count: 2)
    end
  end
end

