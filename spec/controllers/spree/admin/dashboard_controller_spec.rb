require 'spec_helper'

describe Spree::Admin::DashboardController do
  stub_authorization!

  describe '#show' do
    it 'redirect to orders list' do
      get :show
      expect(response).to redirect_to('/admin/orders')
    end
  end
end
