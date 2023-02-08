require 'spec_helper'

describe 'Stock Transfers', type: :feature, js: true do
  stub_authorization!

  let!(:oauth_application) { create(:oauth_application, name: 'Test app') }

  it 'renders a list of applications' do
    visit '/admin/oauth_applications'

    expect(page).to have_content('Test app')
  end

  it 'can create a new app' do
    visit '/admin/oauth_applications/new'

    fill_in 'Name', with: 'My app'
    fill_in 'Scope', with: 'admin'
    click_button 'Create'

    expect(page).to have_content('Client ID')
    expect(page).to have_content('Client Secret')
    expect(page).to have_content(Spree::OauthApplication.last.uid)
  end
  # TODO: uncomment this test when turbo bug is resolved
  # it 'can modify existing app' do
  #   visit "/admin/oauth_applications/#{oauth_application.id}/edit"
  #
  #   fill_in 'Name', with: 'New name', fill_options: { clear: :backspace }
  #   click_button 'Update'
  #   wait_for_turbo
  #
  #   expect(page).to have_content('successfully updated!')
  #   expect(page).to have_content('New name')
  # end
end
