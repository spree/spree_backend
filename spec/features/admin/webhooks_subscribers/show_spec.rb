require 'spec_helper'

describe 'Webhooks::Subscriber#show', type: :feature do
  stub_authorization!

  context '#show' do
    let!(:subscriber) { create(:webhook_subscriber, :active, subscriptions: ['*']) }
    let!(:event) { create(:webhook_event, :successful, subscriber: subscriber) }

    it 'lists the events' do
      visit spree.admin_webhooks_subscriber_path(subscriber)

      expect(page).to have_content(subscriber.url)
      expect(page).to have_content('*')

      within_row(1) { expect(page).to have_content(event.name) }
      within_row(1) { expect(page).to have_content(event.created_at) }
      within_row(1) { expect(page).to have_content(event.response_code) }
    end
  end
end
