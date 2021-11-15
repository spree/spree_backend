require 'spec_helper'

describe 'Webhooks::Subscriber#index', type: :feature do
  stub_authorization!

  context '#index' do
    let!(:subscribers) { create_list(:webhook_subscriber, 3) }
    let!(:events) { create_list(:webhook_event, 3, subscriber: subscribers.first) }
    let!(:latest_event) { create(:webhook_event, subscriber: subscribers.first) }

    before { visit spree.admin_webhooks_subscribers_path }

    it 'lists the subscribers and time of the last event' do
      expect(page).to have_content(subscribers.first.url)
      expect(page).to have_content(subscribers.second.url)
      expect(page).to have_content(subscribers.third.url)
      expect(page).to have_content(latest_event.created_at)
    end

    it 'deletes the subscriber successfully', js: true do
      accept_confirm do
        within_row(1) do
          click_icon(:delete)
        end
      end
      expect(page).to have_content('successfully removed')
    end
  end
end
