require 'spec_helper'

module Spree
  module Admin
    describe WebhooksSubscribersController, type: :controller do
      stub_authorization!

      let!(:webhooks_subscriber) { create(:webhook_subscriber) }

      describe '#index' do
        subject { get :index }

        let!(:webhooks_subscriber2) { create(:webhook_subscriber) }

        before { subject }

        it 'responds with status 200' do
          expect(response.status).to eq(200)
        end

        it 'loads the webhooks_subscribers' do
          expect(assigns(:webhooks_subscribers)).to include webhooks_subscriber
          expect(assigns(:webhooks_subscribers)).to include webhooks_subscriber2
        end
      end

      describe '#new' do
        it 'responds with status 200' do
          get :new
          expect(response.status).to eq(200)
        end
      end

      describe '#create' do
        let(:request) { post :create, params: { webhooks_subscriber: { url: 'https://google.com/path' } } }

        it 'creates a webhooks subscriber' do
          expect { request }.to change(Spree::Webhooks::Subscriber, :count).by(1)
          expect(response).to be_redirect
        end
      end

      describe '#update' do
        let(:new_url) { 'https://facebook.com/path' }

        before { put :update, params: { id: webhooks_subscriber.id, webhooks_subscriber: { url: new_url } } }

        it 'updates the subscriber' do
          expect(webhooks_subscriber.reload.url).to eq(new_url)
        end
      end

      describe '#destroy' do
        before { delete :destroy, params: { id: webhooks_subscriber.id } }

        it 'deletes the subscriber' do
          expect(assigns(:object)).to eq(webhooks_subscriber)
          expect(response).to have_http_status(:found)
          expect(flash[:success]).to include('successfully removed')
        end
      end
    end
  end
end
