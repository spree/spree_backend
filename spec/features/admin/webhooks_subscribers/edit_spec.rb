require 'spec_helper'

describe 'Webhooks::Subscriber#edit', type: :feature do
  stub_authorization!

  before { visit spree.edit_admin_webhooks_subscriber_path(subscriber) }

  context 'when subscribed to all events' do
    let!(:subscriber) { create(:webhook_subscriber, :active, subscriptions: ['*']) }

    it 'has the correct values populated in the fields' do
      expect(page).to have_field(id: 'webhooks_subscriber_url', with: subscriber.url)
      expect(page).to have_field(id: 'webhooks_subscriber_active', checked: true)
      expect(page).to have_field(name: 'subscribe_to_all_events', checked: true)
    end

    it 'updates the subscriber successfully' do
      fill_in 'webhooks_subscriber_url', with: 'https://facebook.com/path'
      uncheck 'webhooks_subscriber_active'
      choose 'subscribe_to_all_events_false'
      check 'webhooks_subscriber_address'
      check 'webhooks_subscriber_line_item'

      click_on 'Update'

      expect(page).to have_content('successfully updated')
      within_row(1) { expect(page).to have_content('https://facebook.com/path') }
      within_row(1) { expect(page).to have_content('address.create, address.delete, address.update') }
      within_row(1) { expect(page).to have_content('line_item.create, line_item.delete, line_item.update') }
    end
  end

  context 'when subscribed to some events' do
    let(:subscriptions) do
      %w[credit_card.create credit_card.update credit_card.delete
         customer_return.create customer_return.update customer_return.delete]
    end
    let!(:subscriber) { create(:webhook_subscriber, :active, subscriptions: subscriptions) }

    it 'checks the correct checkboxes' do
      expect(page).to have_field(id: 'subscribe_to_all_events_false', checked: true)
      expect(page).to have_field(id: 'webhooks_subscriber_credit_card', checked: true)
      expect(page).to have_field(id: 'webhooks_subscriber_customer_return', checked: true)
    end
  end
end

