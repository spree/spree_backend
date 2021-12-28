require 'spec_helper'

describe 'New Page', type: :feature do
  stub_authorization!

  context 'when a user tries to create a new page with no title' do
    before do
      visit spree.new_admin_cms_page_path
    end

    it "warns that the title can't be blank" do
      click_on 'Create'
      expect(page).to have_text ("Title can't be blank")
    end
  end

  context 'when a user tries to create a page with a duplicate slug' do
    let!(:store_1) { create(:store, default: true) }
    let!(:cms_page) { create(:cms_standard_page, title: 'About Us', store: store_1) }

    before do
      visit spree.new_admin_cms_page_path
    end

    it 'warns the user that the slug has already been taken', js: true do
      fill_in 'Title *', with: 'About Us'

      click_on 'Create'
      expect(page).to have_text ('Slug has already been taken')
    end
  end
end
