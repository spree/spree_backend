require 'spec_helper'

describe Spree::Admin::WebhooksSubscribersHelper, type: :helper do
  include Spree::Admin::WebhooksSubscribersHelper

  describe '#event_list_for' do
    subject { event_list_for(resource_name) }

    let(:default_events) { "#{resource_name}.create,#{resource_name}.delete,#{resource_name}.update" }
    let(:resource_name) { :address }

    it 'returns the resource.create, resource.delete and resource.update events' do
      expect(subject).to eq(default_events)
    end
  end
end
