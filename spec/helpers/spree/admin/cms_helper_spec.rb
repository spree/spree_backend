require 'spec_helper'

describe Spree::Admin::CmsHelper, type: :helper do
  let!(:current_store) { create(:store) }

  describe '#cms_page_locale' do
    subject { cms_page_locale(page) }

    context 'when locale is the same as the store\'s' do
      let!(:page) { create(:cms_standard_page, locale: current_store.default_locale) }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when locale is different from store\'s' do
      let(:locale) { 'es' }
      let!(:page) { create(:cms_standard_page, locale: locale) }

      it 'returns the locale' do
        expect(subject).to eq(locale)
      end
    end
  end
end
