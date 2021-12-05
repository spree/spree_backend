require 'spec_helper'

describe Spree::Admin::ShippingMethodsController, type: :controller do
  stub_authorization!

  # Regression test for #1240
  it 'does not hard-delete shipping methods' do
    shipping_method = stub_model(Spree::ShippingMethod)
    allow(Spree::ShippingMethod).to receive_messages find: shipping_method
    expect(shipping_method.deleted_at).to be_nil
    expect { delete :destroy, params: { id: 1 } }.to change { shipping_method.deleted_at }.from(nil)
  end
end
