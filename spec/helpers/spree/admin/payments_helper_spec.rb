require 'spec_helper'

describe Spree::Admin::PaymentsHelper, type: :helper do
  let!(:store) { create(:store) }

  before do
    allow(helper).to receive(:current_store).and_return(store)
    allow(helper).to receive(:spree_current_user).and_return(user)
  end

  describe '#payment_method_name' do
    context 'user with update permission' do
      let(:user) { create(:admin_user) }
      let(:payment_method) { create(:credit_card_payment_method, stores: [store]) }
      let(:payment) { build(:payment, payment_method: payment_method) }

      before do
        allow(helper).to receive(:can?).with(:update, payment_method).and_return(true)
      end

      it 'returns link to payment method edit page' do
        expect(helper.payment_method_name(payment)).to eq("<a href=\"/admin/payment_methods/#{payment_method.id}/edit\">#{payment_method.name}</a>")
      end
    end

    context 'user without update permission' do
      let(:user) { create(:user) }
      let(:payment_method) { create(:credit_card_payment_method, stores: [store]) }
      let(:payment) { build(:payment, payment_method: payment_method) }

      before do
        allow(helper).to receive(:can?).with(:update, payment_method).and_return(false)
      end

      it 'returns payment method name' do
        expect(helper.payment_method_name(payment)).to eq(payment_method.name)
      end
    end
  end
end
