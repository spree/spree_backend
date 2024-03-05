require 'spec_helper'

describe 'New Promotion Batches', type: :feature, js: true do
  stub_authorization!

  context 'when object is created' do
    let!(:template_promotion) { create(:promotion, name: 'Template Promotion', template: true) }

    before do
      visit spree.new_admin_template_promotion_promotion_batch_path(template_promotion_id: template_promotion.id)
      fill_in 'Number of codes to generate', with: 2
      fill_in 'Number of random characters to generate for each code', with: 10
    end

    it 'have specified number of codes' do
      click_button 'Create'
      wait_for_turbo

      expect(template_promotion.promotion_batches.length).to eq(1)

      promotion_batch = template_promotion.promotion_batches.first

      expect(promotion_batch.codes.length).to eq(2)
    end

    it 'have codes with specified length' do
      click_button 'Create'
      wait_for_turbo

      expect(template_promotion.promotion_batches.length).to eq(1)
      promotion_batch = template_promotion.promotion_batches.first
      promotion_batch.codes.each do |code|
        expect(code.length).to eq(10)
      end
    end

    it 'have specified suffixes and prefixes' do
      prefix, suffix = 'prefix', 'suffix'

      fill_in '(Optional) Prefix', with: prefix
      fill_in '(Optional) Suffix', with: suffix

      click_button 'Create'
      wait_for_turbo

      promotion_batch = template_promotion.promotion_batches.first

      promotion_batch.codes.each do |code|
        expect(code).to match("^#{prefix}[A-Z0-9]{10}#{suffix}$")
      end
    end
  end

  context 'create promotions' do
    let!(:template_promotion) {
      create(:promotion,
             name: 'Template Promotion',
             description: 'Template Promotion Description',
             template: true,
             starts_at: DateTime.new(2012, 1, 18, 16, 45),
             expires_at: DateTime.new(2012, 1, 18, 16, 45))
    }

    before do
      visit spree.new_admin_template_promotion_promotion_batch_path(template_promotion_id: template_promotion.id)
      fill_in 'Number of codes to generate', with: 2
      fill_in 'Number of random characters to generate for each code', with: 10
    end

    it 'in specified number' do
      click_button 'Create'
      wait_for_turbo

      promotion_batch = template_promotion.promotion_batches.first
      expect(promotion_batch.state).to eq('completed')
      expect(promotion_batch.promotions.count).to eq(2)
    end

    it 'that have the same properties as the template promotion' do
      click_button 'Create'
      wait_for_turbo

      promotion_batch = template_promotion.promotion_batches.first
      expect(promotion_batch.state).to eq('completed')

      promotion_batch.promotions.each do |promotion|
        expect(promotion.name).to eq(template_promotion.name)
        expect(promotion.description).to eq(template_promotion.description)
        expect(promotion.starts_at).to eq(template_promotion.starts_at)
        expect(promotion.expires_at).to eq(template_promotion.expires_at)
      end
    end
  end

  context 'after creating promotions' do

    let!(:template_promotion1) { create(:promotion, name: 'Template Promotion 1', template: true) }
    let!(:template_promotion2) { create(:promotion, name: 'Template Promotion 2', template: true) }

    before do
      [template_promotion1, template_promotion2].each do |template|
        2.times do
          visit spree.new_admin_template_promotion_promotion_batch_path(template_promotion_id: template.id)
          fill_in 'Number of codes to generate', with: 2
          fill_in 'Number of random characters to generate for each code', with: 10
          click_button 'Create'
          wait_for_turbo
        end
      end

    end
    it 'allows displaying created promotions filtered by template promotion' do
      visit spree.admin_promotions_path({ q: { for_template_promotion_id: template_promotion1.id } })
      expect(page).to have_content('Template Promotion 1', minimum: 4)
      expect(page).to have_no_content('Template Promotion 2')
    end

    it 'allows displaying created promotions filtered by promotion batch' do
      visit spree.admin_promotions_path({ q: { promotion_batch_id_eq: template_promotion1.promotion_batches.first.id } })
      expect(page).to have_content('Template Promotion 1', maximum: 2)
      expect(page).to have_no_content('Template Promotion 2')
    end

  end

  context 'CSV files' do
    let!(:template_promotion) { create(:promotion, name: 'Template Promotion', template: true) }

    let(:file_path) { Rails.root + '../../spec/support/promotion_batch_codes.csv' }

    before do
      visit spree.import_admin_template_promotion_promotion_batches_path(template_promotion_id: template_promotion.id)
    end

    it 'import properly' do
      attach_file('file', file_path)
      click_button 'Create'
      wait_for_turbo

      promotion_batch = Spree::PromotionBatch.first
      expect(promotion_batch.codes).to match_array(['CODE1', 'CODE2'])
    end
  end
end

