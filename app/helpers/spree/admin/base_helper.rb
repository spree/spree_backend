module Spree
  module Admin
    module BaseHelper
      SELECT2_SUPPORTED_LOCALES = %w[
        af ar az bg bn bs ca cs da de dsb el en eo es et eu fa fi fr gl he
        hi hr hsb hu hy id is it ja ka km ko lt lv mk ms nb ne nl pa pl ps
        pt pt-BR ro ru sk sl sq sr sr-Cyrl sv th tk tr uk vi zh-CN zh-TW
      ].freeze

      FLATPICKR_SUPPORTED_LOCALES = %w[
        ar at az be bg bn bs cs cy da de eo es et fa fi fo fr ga gr he
        hi hr hu id is it ja ka km ko kz lv mk mn ms my nl no pa pl pt ro ru
        si sk sl sq sr sv th tr uk uz vn zh
      ].freeze

      def flash_alert(flash)
        if flash.present?
          type = flash.first[0]
          message = flash.first[1]
          content_tag(:span, message, class: 'd-none', data: { alert_type: type })
        end
      end

      def field_container(model, method, options = {}, &block)
        css_classes = options[:class].to_a
        css_classes << 'form-group'
        css_classes << 'withError' if error_message_on(model, method).present?
        content_tag(
          :div, capture(&block),
          options.merge(class: css_classes.join(' '), id: "#{model}_#{method}_field")
        )
      end

      # Returns Humanized Dropdown Values From a Constant In the Model
      # Pass the model name as a string and then a hash containing the constant name
      # and the option to paramatize the return value.
      #
      # Example:
      #
      #   spree_humanize_dropdown_values('Spree::CmsPage', { const: 'TYPES' })
      #   spree_humanize_dropdown_values('Spree::Menu', { const: 'MENU_TYPES', paramterize_values: true })
      #
      def spree_humanize_dropdown_values(model_name, options = {})
        formatted_option_values = []

        const = options[:const] || nil
        paramterize_values = options[:paramterize_values] || false

        return unless const.present?

        model_name.constantize.const_get(const).map do |type|
          return_value = if paramterize_values
                           type.parameterize(separator: '_')
                         else
                           type
                         end

          formatted_option_values << [spree_humanize_type(type), return_value]
        end

        formatted_option_values
      end

      def spree_humanize_type(obj)
        last_word = obj.split('::', 10).last

        if last_word.starts_with?('Cms')
          last_word.slice(3, 100).gsub(/(?<=[a-z])(?=[A-Z])/, ' ')
        else
          last_word.gsub(/(?<=[a-z])(?=[A-Z])/, ' ')
        end
      end

      def error_message_on(object, method, _options = {})
        object = convert_to_model(object)
        obj = object.respond_to?(:errors) ? object : instance_variable_get("@#{object}")

        if obj && obj.errors[method].present?
          errors = safe_join(obj.errors[method], '<br />'.html_safe)
          content_tag(:span, errors, class: 'formError')
        else
          ''
        end
      end

      def svg_icon(name:, classes: '', width:, height:)
        if name.ends_with?('.svg')
          icon_name = File.basename(name, File.extname(name))
          inline_svg_tag "backend-#{icon_name}.svg", class: "icon-#{icon_name} #{classes}", size: "#{width}px*#{height}px"
        else
          inline_svg_tag "backend-#{name}.svg", class: "icon-#{name} #{classes}", size: "#{width}px*#{height}px"
        end
      end

      def datepicker_field_value(date)
        unless date.blank?
          l(date, format: '%Y/%m/%d')
        end
      end

      def preference_field_tag(name, value, options)
        if options[:key] == :currency
          return select_tag(name,
                            options_from_collection_for_select(supported_currencies_for_all_stores, :iso_code, :iso_code, value),
                            class: 'select2')
        end

        case options[:type]
        when :integer
          text_field_tag(name, value, preference_field_options(options))
        when :boolean
          hidden_field_tag(name, 0, id: "#{name}_hidden") +
            check_box_tag(name, 1, value, preference_field_options(options))
        when :string
          text_field_tag(name, value, preference_field_options(options))
        when :password
          password_field_tag(name, value, preference_field_options(options))
        when :text
          text_area_tag(name, value, preference_field_options(options))
        else
          text_field_tag(name, value, preference_field_options(options))
        end
      end

      def preference_field_for(form, field, options)
        case options[:type]
        when :integer
          form.text_field(field, preference_field_options(options))
        when :boolean
          form.check_box(field, preference_field_options(options))
        when :string
          form.text_field(field, preference_field_options(options))
        when :password
          form.password_field(field, preference_field_options(options))
        when :text
          form.text_area(field, preference_field_options(options))
        else
          form.text_field(field, preference_field_options(options))
        end
      end

      def preference_field_options(options)
        field_options = case options[:type]
                        when :integer
                          {
                            size: 10,
                            class: 'input_integer form-control'
                          }
                        when :boolean
                          {
                            class: 'form-check-input'
                          }
                        when :string
                          {
                            size: 10,
                            class: 'input_string form-control'
                          }
                        when :password
                          {
                            size: 10,
                            class: 'password_string form-control'
                          }
                        when :text
                          {
                            rows: 15,
                            cols: 85,
                            class: 'form-control'
                          }
                        else
                          {
                            size: 10,
                            class: 'input_string form-control'
                          }
                        end

        field_options.merge!(readonly: options[:readonly],
                             disabled: options[:disabled],
                             size: options[:size])
      end

      def preference_fields(object, form)
        return unless object.respond_to?(:preferences)

        fields = object.preferences.keys.map do |key|
          if object.has_preference?(key)
            case key
            when :currency
              content_tag(:div, form.label("preferred_#{key}", Spree.t(key)) +
                (form.select "preferred_#{key}", currency_options(object.preferences[key]), {}, { class: 'form-control select2' }),
                          class: 'form-group', id: [object.class.to_s.parameterize, 'preference', key].join('-'))
            else
              if object.preference_type(key).to_sym == :boolean
                content_tag(:div, preference_field_for(form, "preferred_#{key}", type: object.preference_type(key)) +
                  form.label("preferred_#{key}", Spree.t(key), class: 'form-check-label'),
                            class: 'form-group form-check', id: [object.class.to_s.parameterize, 'preference', key].join('-'))
              else
                content_tag(:div, form.label("preferred_#{key}", Spree.t(key)) +
                  preference_field_for(form, "preferred_#{key}", type: object.preference_type(key)),
                            class: 'form-group', id: [object.class.to_s.parameterize, 'preference', key].join('-'))
              end
            end
          end
        end
        safe_join(fields)
      end

      # renders hidden field and link to remove record using nested_attributes
      def link_to_icon_remove_fields(form)
        url = form.object.persisted? ? [:admin, form.object] : '#'
        link_to_with_icon('delete.svg', '', url,
                          class: 'spree_remove_fields btn btn-sm btn-danger',
                          data: {
                            action: 'remove'
                          },
                          title: Spree.t(:remove),
                          no_text: true
                         ) + form.hidden_field(:_destroy)
      end

      def spree_dom_id(record)
        dom_id(record, 'spree')
      end

      I18N_PLURAL_MANY_COUNT = 2.1
      def plural_resource_name(resource_class)
        resource_class.model_name.human(count: I18N_PLURAL_MANY_COUNT)
      end

      def order_time(time)
        return '' if time.blank?

        [I18n.l(time.to_date), time.strftime('%l:%M %p %Z').strip].join(' ')
      end

      def required_span_tag
        content_tag(:span, ' *', class: 'required font-weight-bold text-danger')
      end

      def product_preview_link(product)
       ActiveSupport::Deprecation.warn(<<-DEPRECATION, caller)
         Admin::BaseHelper#product_preview_link is deprecated and will be removed in Spree 5.0. - Use Admin::BaseHelper#external_page_preview_link
       DEPRECATION

        external_page_preview_link(product)
      end

      def taxon_preview_link(taxon)
        ActiveSupport::Deprecation.warn(<<-DEPRECATION, caller)
          Admin::BaseHelper#taxon_preview_link is deprecated and will be removed in Spree 5.0. - Use Admin::BaseHelper#external_page_preview_link
        DEPRECATION

        external_page_preview_link(taxon)
      end

      def external_page_preview_link(resource, options = {})
        resource_name = options[:name] || resource.class.name.demodulize

        button_link_to(
          Spree.t('admin.utilities.preview', name: resource_name ),
          spree_storefront_resource_url(resource),
          class: 'btn-outline-secondary', icon: 'view.svg', id: "adminPreview#{resource_name}", target: :blank, data: { turbo: false }
        )
      end

      def admin_logout_link
        if defined?(admin_logout_path)
          admin_logout_path
        elsif defined?(spree_logout_path)
          spree_logout_path
        end
      end

      def select2_local_fallback
        stripped_locale = I18n.locale.to_s.split('-').first

        if ['zh-CN', 'zh-TW', 'sr-Cyrl', 'pt-BR'].include?(I18n.locale.to_s)
          I18n.locale
        elsif SELECT2_SUPPORTED_LOCALES.include? stripped_locale
          stripped_locale
        else
          'en'
        end
      end

      def flatpickr_local_fallback
        stripped_locale = I18n.locale.to_s.split('-').first

        if I18n.locale.to_s == 'zh-TW'
          # Taiwanese is a popular language in Spree,
          # it has been well translated.
          'zh-tw'
        elsif FLATPICKR_SUPPORTED_LOCALES.include? stripped_locale
          stripped_locale
        else
          'default'
        end
      end

      def product_wysiwyg_editor_enabled?
        Spree::Backend::Config[:product_wysiwyg_editor_enabled]
      end

      def taxon_wysiwyg_editor_enabled?
        Spree::Backend::Config[:taxon_wysiwyg_editor_enabled]
      end
    end
  end
end
