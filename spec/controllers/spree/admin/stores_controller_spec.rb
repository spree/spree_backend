require 'spec_helper'

describe Spree::Admin::StoresController do
  stub_authorization!

  let!(:store)          { create(:store) }
  let(:image_file)      { Rack::Test::UploadedFile.new(Spree::Backend::Engine.root.join('spec', 'fixtures', 'thinking-cat.jpg')) }
  let(:store_with_logo) { create(:store, logo: image_file) }

  describe '#create' do
    it 'redirects to stores index page using the newly created store URL' do
      post :create, params: {
        store: { name: 'New Test Store',
                 code: 'NTSS',
                 mail_from_address: 'testing@example.com',
                 url: 'test-new-store.lvh.me',
                 default_locale: 'en',
                 default_currency: 'USD',
                 supported_currencies: ['USD,GBP'],
                 supported_locales: ['en'] }
      }

      expect(response).to redirect_to('http://test-new-store.lvh.me/admin')
    end
  end

  describe '#update' do
    it 'can update logo' do
      put :update, params: { id: store.to_param, store: { logo_attributes: { attachment: image_file } } }

      expect(store.reload.logo.attachment.blob.filename).to eq(image_file.original_filename)
    end
  end
end
