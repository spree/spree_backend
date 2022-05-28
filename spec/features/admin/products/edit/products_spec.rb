require 'spec_helper'

describe 'Product Details', type: :feature, js: true do
  stub_authorization!

  let!(:product) { create(:product, name: 'Bún thịt nướng', sku: 'A100', description: 'lorem ipsum') }

  context 'editing a product with WYSIWYG disabled' do
    before do
      Spree::Backend::Config.product_wysiwyg_editor_enabled = false
      visit spree.admin_product_path(product)
    end

    after { Spree::Backend::Config.product_wysiwyg_editor_enabled = true }

    it 'displays the product description as a standard input field' do
      expect(page).to have_field(id: 'product_description', with: product.description)
      expect(page).not_to have_css('#product_description_ifr')
    end
  end

  context 'editing a product with WYSIWYG editor enabled' do
    before do
      Spree::Backend::Config.product_wysiwyg_editor_enabled = true
      visit spree.admin_product_path(product)
    end

    it 'displays the product details with a WYSIWYG editor for the product description input' do
      expect(page).to have_css('.content-header', text: 'Bún thịt nướng')
      expect(page).to have_field(id: 'product_name', with: 'Bún thịt nướng')
      expect(page).to have_field(id: 'product_slug', with: 'bun-th-t-n-ng')
      expect(page).not_to have_field(id: 'product_description')
      expect(page).to have_css('#product_description_ifr')
      expect(page).to have_field(id: 'product_price', with: '19.99')
      expect(page).to have_field(id: 'product_cost_price', with: '17.00')
      expect(page).to have_field(id: 'product_sku', with: 'A100')
    end

    it 'shows product description using wysiwyg editor' do
      expect(page).not_to have_field(id: 'product_description', with: 'lorem ipsum')
      expect(page).to have_css('#product_description_ifr')
    end

    it 'handles slug changes' do
      fill_in 'product_slug', with: 'random-slug-value'
      click_button 'Update'
      expect(page).to have_content('successfully updated!')
    end

    it 'has a link to preview a product' do
      allow(Spree::Core::Engine).to receive(:frontend_available?).and_return(true)

      click_link 'Details'

      expect(page).to have_css('#adminPreviewProduct')
      expect(page).to have_link Spree.t(:preview_product), href: "http://www.example.com/products/bun-th-t-n-ng"
    end
  end

  describe 'status related fields behavior' do
    before do
      visit spree.admin_product_path(product)
    end

    it 'hides make available_on' do
      expect(page).to have_field(id: 'product_status', with: 'active')
      expect(page).to have_content('Available On')
      expect(page).not_to have_content('Make Active At')
      expect(page).to have_content('Discontinue On')
    end

    it 'hides discontinue_on' do
      select 'draft', from: 'Status'
      expect(page).to have_content('Available On')
      expect(page).to have_content('Make Active At')
      expect(page).to have_content('Discontinue On')
    end

    it 'hides all fields' do
      select 'archived', from: 'Status'
      expect(page).not_to have_content('Available On')
      expect(page).not_to have_content('Make Active At')
      expect(page).to have_content('Discontinue On')
    end
  end

  describe 'metadata behavior' do
    before do
      visit spree.admin_product_path(product)
    end

    context 'Public Metadata' do
      it 'creates new metadata' do
        within('tbody#public_metadata_form') do
          find("input[name='[public_metadata][key][]']").set("Foot Size")
          find("input[name='[public_metadata][value][]']").set("44")
        end
        click_button 'Update'
         wait_for_turbo

        expect(page).to have_css('tr#public_metadata_row_foot_size')
        expect(page).to have_field("[public_metadata][previous_key][]", type: :hidden, with: "foot_size")
        expect(page).to have_field("[public_metadata][key][]", with: "foot_size")
        expect(page).to have_field("[public_metadata][value][]", with: "44")
      end

      it 'updates metadata' do
        within('tbody#public_metadata_form') do
          find("input[name='[public_metadata][key][]']").set("Pet Breed")
          find("input[name='[public_metadata][value][]']").set("Miniature Schnauzer")
        end
        click_button 'Update'
        wait_for_turbo

        expect(page).to have_css('tr#public_metadata_row_pet_breed')
        expect(page).to have_field("[public_metadata][previous_key][]", type: :hidden, with: "pet_breed")
        expect(page).to have_field("[public_metadata][key][]", with: "pet_breed")
        expect(page).to have_field("[public_metadata][value][]", with: "Miniature Schnauzer")

        within('tbody#public_metadata_form') do
          find(:xpath, '//*[@id="public_metadata_key_0"]').set("Pet Type")
          find(:xpath, '//*[@id="product_public_metadata_value_0"]').set("Pug")
        end

        click_button 'Update'
        wait_for_turbo

        expect(page).not_to have_css('tr#public_metadata_row_pet_breed')
        expect(page).not_to have_field("[public_metadata][previous_key][]", type: :hidden, with: "pet_breed")
        expect(page).not_to have_field("[public_metadata][key][]", with: "pet_breed")
        expect(page).not_to have_field("[public_metadata][value][]", with: "Miniature Schnauzer")

        expect(page).to have_css('tr#public_metadata_row_pet_type')
        expect(page).to have_field("[public_metadata][previous_key][]", type: :hidden, with: "pet_type")
        expect(page).to have_field("[public_metadata][key][]", with: "pet_type")
        expect(page).to have_field("[public_metadata][value][]", with: "Pug")
      end

      it 'deletes metadata' do
        within('tbody#public_metadata_form') do
          find("input[name='[public_metadata][key][]']").set("Dress Size")
          find("input[name='[public_metadata][value][]']").set("10")
        end

        click_button 'Update'
        wait_for_turbo

        expect(page).to have_css('tr#public_metadata_row_dress_size')
        expect(page).to have_field("[public_metadata][previous_key][]", type: :hidden, with: "dress_size")
        expect(page).to have_field("[public_metadata][key][]", with: "dress_size")
        expect(page).to have_field("[public_metadata][value][]", with: "10")

        find(:xpath, '//*[@id="public_metadata_row_dress_size"]/td[2]/a').click
        page.driver.browser.switch_to.alert.accept
        wait_for_turbo

        expect(page).not_to have_css('tr#public_metadata_row_dress_size')
        expect(page).not_to have_field("[public_metadata][previous_key][]", type: :hidden, with: "dress_size")
        expect(page).not_to have_field("[public_metadata][key][]", with: "dress_size")
        expect(page).not_to have_field("[public_metadata][value][]", with: "10")
      end

      it 'adds new rows' do
        within('tbody#public_metadata_form') do
          find(:xpath, '//*[@id="add_public_metadata_fields_form"]/a').click
          find(:xpath, '//*[@id="add_public_metadata_fields_form"]/a').click
        end

        wait_for_turbo

        expect(page).to have_selector('tbody#public_metadata_form tr', minimum: 3)
      end
    end

    context 'Private Metadata' do
      it 'creates new metadata' do
        within('tbody#private_metadata_form') do
          find("input[name='[private_metadata][key][]']").set("Foot Size")
          find("input[name='[private_metadata][value][]']").set("44")
        end
        click_button 'Update'
         wait_for_turbo

        expect(page).to have_css('tr#private_metadata_row_foot_size')
        expect(page).to have_field("[private_metadata][previous_key][]", type: :hidden, with: "foot_size")
        expect(page).to have_field("[private_metadata][key][]", with: "foot_size")
        expect(page).to have_field("[private_metadata][value][]", with: "44")
      end

      it 'updates metadata' do
        within('tbody#private_metadata_form') do
          find("input[name='[private_metadata][key][]']").set("Pet Breed")
          find("input[name='[private_metadata][value][]']").set("Miniature Schnauzer")
        end
        click_button 'Update'
        wait_for_turbo

        expect(page).to have_css('tr#private_metadata_row_pet_breed')
        expect(page).to have_field("[private_metadata][previous_key][]", type: :hidden, with: "pet_breed")
        expect(page).to have_field("[private_metadata][key][]", with: "pet_breed")
        expect(page).to have_field("[private_metadata][value][]", with: "Miniature Schnauzer")

        within('tbody#private_metadata_form') do
          find(:xpath, '//*[@id="private_metadata_key_0"]').set("Pet Type")
          find(:xpath, '//*[@id="product_private_metadata_value_0"]').set("Pug")
        end

        click_button 'Update'
        wait_for_turbo

        expect(page).not_to have_css('tr#private_metadata_row_pet_breed')
        expect(page).not_to have_field("[private_metadata][previous_key][]", type: :hidden, with: "pet_breed")
        expect(page).not_to have_field("[private_metadata][key][]", with: "pet_breed")
        expect(page).not_to have_field("[private_metadata][value][]", with: "Miniature Schnauzer")

        expect(page).to have_css('tr#private_metadata_row_pet_type')
        expect(page).to have_field("[private_metadata][previous_key][]", type: :hidden, with: "pet_type")
        expect(page).to have_field("[private_metadata][key][]", with: "pet_type")
        expect(page).to have_field("[private_metadata][value][]", with: "Pug")
      end

      it 'deletes metadata' do
        within('tbody#private_metadata_form') do
          find("input[name='[private_metadata][key][]']").set("Dress Size")
          find("input[name='[private_metadata][value][]']").set("10")
        end

        click_button 'Update'
        wait_for_turbo

        expect(page).to have_css('tr#private_metadata_row_dress_size')
        expect(page).to have_field("[private_metadata][previous_key][]", type: :hidden, with: "dress_size")
        expect(page).to have_field("[private_metadata][key][]", with: "dress_size")
        expect(page).to have_field("[private_metadata][value][]", with: "10")

        find(:xpath, '//*[@id="private_metadata_row_dress_size"]/td[2]/a').click
        page.driver.browser.switch_to.alert.accept
        wait_for_turbo

        expect(page).not_to have_css('tr#private_metadata_row_dress_size')
        expect(page).not_to have_field("[private_metadata][previous_key][]", type: :hidden, with: "dress_size")
        expect(page).not_to have_field("[private_metadata][key][]", with: "dress_size")
        expect(page).not_to have_field("[private_metadata][value][]", with: "10")
      end

      it 'adds new rows' do
        within('tbody#private_metadata_form') do
          find(:xpath, '//*[@id="add_private_metadata_fields_form"]/a').click
          find(:xpath, '//*[@id="add_private_metadata_fields_form"]/a').click
        end

        wait_for_turbo

        expect(page).to have_selector('tbody#private_metadata_form tr', minimum: 3)
      end
    end
  end
end
