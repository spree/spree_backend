require 'spec_helper'

describe Spree::Admin::ShippingMethodsController, type: :controller do
  stub_authorization!

  # Regression test for #1240
  it 'does not hard-delete shipping methods' do
    shipping_method = stub_model(Spree::ShippingMethod)
    allow(Spree::ShippingMethod).to receive_messages find: shipping_method
    expect(shipping_method.deleted_at).to be_nil
    delete :destroy, params: { id: 1 }
    expect(shipping_method.reload.deleted_at).not_to be_nil
  end
end
