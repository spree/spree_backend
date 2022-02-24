require 'spec_helper'

describe Spree::Admin::ProductsHelper, type: :helper do
  context '#available_status' do
    subject(:status) { helper.available_status(product) }

    let(:store) { Spree::Store.default }
    let(:product) { create(:product, stores: [store]) }

    context 'product is available' do
      it 'has available status' do
        expect(status).to eq(Spree.t('admin.product.active'))
      end
    end

    context 'product was deleted' do
      before do
        product.delete
      end

      it 'has deleted status' do
        expect(status).to eq(Spree.t('admin.product.deleted'))
      end
    end

    context 'product is discontinued' do
      before do
        product.discontinue!
      end

      it 'has discontinued status' do
        expect(status).to eq(Spree.t('admin.product.archived'))
      end
    end

    context 'draft product' do
      before do
        product.status = 'draft'
      end

      it 'has draft status' do
        expect(status).to eq(Spree.t('admin.product.draft'))
      end
    end
  end
end
