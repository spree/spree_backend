require 'spec_helper'

describe 'Template Promotion', type: :feature, js: true do
  stub_authorization!

  let(:store) { Spree::Store.default }
  let!(:store_2) { create(:store) }
  let(:promotion_name) { 'Template Promotion' }

  context 'is distinct from regular promotions' do
    before do
      visit spree.new_admin_template_promotion_path
    end

    it 'has template property equal to true' do
      fill_in 'Name', with: promotion_name

      click_button 'Create'
      wait_for_turbo

      promotion = store.promotions.find_by!(name: promotion_name)
      expect(promotion.template).to eq(true)
    end

    it "doesn't allow specifying a code" do
      expect(page).to have_no_content('Code')
    end

    it "doesn't appear in promotions list" do
      fill_in 'Name', with: promotion_name

      click_button 'Create'
      wait_for_turbo

      promotion = store.promotions.find_by!(name: promotion_name)
      expect(promotion.name).to eq(promotion_name)
      visit spree.admin_promotions_path
      expect(page).to have_no_content(promotion_name)
    end
  end

  context 'while being created' do
    before do
      visit spree.new_admin_template_promotion_path
    end

    it 'allows you to set a promotion with start and end time' do
      fill_in 'Name', with: promotion_name

      fill_in_date_picker('promotion_starts_at', { year: 2012, month: 1, day: 18, hour: 16, minute: 45 })
      fill_in_date_picker('promotion_expires_at', { year: 2013, month: 3, day: 25, hour: 22, minute: 10 })

      click_button 'Create'
      wait_for_turbo

      promotion = store.promotions.find_by!(name: promotion_name)
      expect(promotion.starts_at).to eq(DateTime.new(2012, 1, 18, 16, 45))
      expect(promotion.expires_at).to eq(DateTime.new(2013, 3, 25, 22, 10))
    end

    it 'allows assigning multiple stores' do
      fill_in 'Name', with: promotion_name
      select2 store_2.unique_name, from: 'Stores'

      click_button 'Create'
      wait_for_turbo

      expect(page).to have_content('successfully created')

      promotion = store.promotions.find_by!(name: promotion_name)
      expect(promotion.stores).to contain_exactly(store, store_2)
    end
  end
end
