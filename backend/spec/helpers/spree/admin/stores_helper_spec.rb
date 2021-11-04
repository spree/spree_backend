require 'spec_helper'

describe Spree::Admin::StoresHelper, type: :helper do
  describe '#selected_checkout_zone' do
    let!(:store) { Spree::Store.default }
    let!(:country) { store.default_country }
    let!(:country_zone) { create(:zone, name: 'CountryZone', kind: 'country') }

    context 'with checkout_zone_id set on store' do
      before do
        country_zone.members.create(zoneable: country)
        store.update(checkout_zone_id: country_zone.id)
      end

      it 'return countries' do
        expect(selected_checkout_zone(store)).to eq country_zone
      end
    end
  end
end
