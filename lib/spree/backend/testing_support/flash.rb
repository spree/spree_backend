module Spree
  module Backend
    module TestingSupport
      module Flash
        def assert_admin_flash_alert_success(message)
          message_content = convert_flash(message)

          within('#FlashAlertsContainer', visible: :all) do
            expect(page).to have_css('span[data-alert-type="success"]', text: message_content, visible: :all)
          end
        end

        def assert_admin_flash_alert_error(message)
          message_content = convert_flash(message)

          within('#FlashAlertsContainer', visible: :all) do
            expect(page).to have_css('span[data-alert-type="error"]', text: message_content, visible: :all)
          end
        end

        def assert_admin_flash_alert_notice(message)
          message_content = convert_flash(message)

          within('#FlashAlertsContainer', visible: :all) do
            expect(page).to have_css('span[data-alert-type="notice"]', text: message_content, visible: :all)
          end
        end

        private

        def convert_flash(flash)
          flash = Spree.t(flash) if flash.is_a?(Symbol)
          flash
        end
      end
    end
  end
end
