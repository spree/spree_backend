require 'spec_helper'

describe Spree::Admin::WebhooksSubscribersHelper, type: :helper do
  include Spree::Admin::WebhooksSubscribersHelper

  describe '#event_list_for' do
    subject { event_list_for(resource_name) }

    let(:default_events) { "#{resource_name}.create,#{resource_name}.update,#{resource_name}.delete" }

    context 'when only default events' do
      let(:resource_name) { :address }

      it 'returns the resource.create, resource.update and resource.delete events' do
        expect(subject).to eq(default_events)
      end
    end

    context 'when it has additional events' do
      before do
        allow(Spree::Webhooks::Subscriber::LIST_OF_ALL_EVENTS).to receive(:include?).with(resource_name).and_return(true)
        allow(Spree::Webhooks::Subscriber::LIST_OF_ALL_EVENTS).to receive(:[]).with(resource_name).and_return(additional_events)
      end

      let(:additional_events) { %W[#{resource_name}.event1 #{resource_name}.event2] }
      let(:resource_name) { :product }

      it 'returns the default events and the additional events' do
        expect(subject).to eq("#{default_events},#{additional_events.join(',')}")
      end
    end
  end
end
