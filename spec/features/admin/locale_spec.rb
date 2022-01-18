require 'spec_helper'

describe 'setting locale', type: :feature do
  stub_authorization!

  before do
    I18n.locale = I18n.default_locale
    I18n.backend.store_translations(:fr,
                                    date: {
                                      month_names: []
                                    },
                                    spree: {
                                      admin: {
                                        orders: { all_orders: 'Tous Les Ordres' }
                                      }
                                    })
    Spree::Backend::Config[:locale] = 'fr'
  end

  after do
    I18n.locale = I18n.default_locale
    Spree::Backend::Config[:locale] = 'en'
  end

  it 'is in french' do
    visit spree.admin_path
    expect(page.body).to have_content('Tous Les Ordres')
  end
end
