require 'spec_helper'

describe 'Product Translations', type: :feature, js: true do
  stub_authorization!

  let(:store) { Spree::Store.default }
  let(:product) { create(:product, stores: [store], name: 'Old Product Name EN') }

  context 'managing translations' do
    context 'when there is more than one locale configured for a store' do
      before do
        store.update!(default_locale: 'en', supported_locales: 'en,fr')
      end

      it 'allows an admin to update all translations' do
        visit spree.admin_product_path(product)

        click_link 'Translations'

        fill_in 'translation_name_en', with: 'Product Name EN', fill_options: { clear: :backspace }
        fill_in 'translation_name_fr', with: 'Product Name FR'
        click_button 'Update'

        wait_for_turbo

        expect(product.translations.count).to eq(1)

        translation_fr = product.translations.find_by!(locale: 'fr')
        expect(translation_fr.name).to eq('Product Name FR')
        expect(translation_fr.slug).to eq('product-name-fr')

        expect(product.reload.name).to eq('Product Name EN')
        expect(product.name_en).to eq('Product Name EN')
      end

      context 'when changing translations after switching store default locale' do
        before do
          store.update!(default_locale: 'fr')
        end

        it 'allows an admin to update all translations' do
          visit spree.admin_product_path(product.id)

          click_link 'Translations'

          fill_in 'translation_name_en', with: 'Product Name EN', fill_options: { clear: :backspace }
          fill_in 'translation_name_fr', with: 'Product Name FR'
          click_button 'Update'

          wait_for_turbo

          expect(product.translations.count).to eq(1)

          translation_fr = product.translations.find_by!(locale: 'fr')
          expect(translation_fr.name).to eq('Product Name FR')
          expect(translation_fr.slug).to eq('product-name-fr')

          expect(product.reload.name).to eq('Product Name EN')
          expect(product.name_en).to eq('Product Name EN')
        end
      end

      context 'when there are no translations for a given language' do
        let(:new_translation) { 'This is a test French translation' }
        let(:expected_new_slug) { 'this-is-a-test-french-translation' }

        it 'allows an admin to add new name translations and generates slug' do
          visit spree.admin_product_path(product)

          click_link 'Translations'
          fill_in 'translation_name_fr', with: new_translation
          click_button 'Update'

          wait_for_turbo

          expect(product.translations.count).to eq(1)

          translation_fr = product.translations.find_by!(locale: 'fr')
          expect(translation_fr.name).to eq(new_translation)
          expect(translation_fr.slug).to eq(expected_new_slug)
        end
      end

      context 'when there are existing translations for a given language' do
        let(:old_name_translation) { 'Old translation' }
        let(:old_slug_translation) { 'old-slug' }
        let(:new_name_translation) { 'New translation' }
        let(:new_slug_translation) { 'new-slug' }

        before do
          product.translations.create!(locale: 'fr', name: old_name_translation, slug: old_slug_translation)
        end

        it 'allows an admin to update existing name translations without updating slug' do
          visit spree.admin_product_path(product)

          click_link 'Translations'
          expect(page).to have_field('translation_name_fr', with: old_name_translation)
          expect(page).to have_field('translation_slug_fr', with: old_slug_translation)

          fill_in 'translation_name_fr', with: new_name_translation
          click_button 'Update'

          wait_for_turbo

          expect(product.translations.count).to eq(1)

          translation_fr = product.translations.find_by!(locale: 'fr')
          expect(translation_fr.name).to eq(new_name_translation)
          expect(translation_fr.slug).to eq(old_slug_translation)
        end

        it 'allows an admin to update slug for a translation' do
          visit spree.admin_product_path(product)

          click_link 'Translations'
          expect(page).to have_field('translation_name_fr', with: old_name_translation)
          expect(page).to have_field('translation_slug_fr', with: old_slug_translation)

          fill_in 'translation_name_fr', with: new_name_translation
          fill_in 'translation_slug_fr', with: new_slug_translation
          click_button 'Update'

          wait_for_turbo

          expect(product.translations.count).to eq(1)

          translation_fr = product.translations.find_by!(locale: 'fr')
          expect(translation_fr.name).to eq(new_name_translation)
          expect(translation_fr.slug).to eq(new_slug_translation)
        end
      end
    end

    context 'when there is only a single locale configured for a store' do
      before do
        store.update!(default_locale: 'en', supported_locales: 'en')
      end

      it "displays a message that translations aren't configured for the store" do
        visit spree.admin_product_path(product)

        click_link 'Translations'
        expect(page).to have_content("To use translations, configure more than one locale for the store.")
      end
    end
  end
end
