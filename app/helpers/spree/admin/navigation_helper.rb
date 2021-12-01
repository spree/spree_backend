module Spree
  module Admin
    module NavigationHelper
      # Makes an admin navigation tab (<li> tag) that links to a routing resource under /admin.
      # The arguments should be a list of symbolized controller names that will cause this tab to
      # be highlighted, with the first being the name of the resource to link (uses URL helpers).
      #
      # Option hash may follow. Valid options are
      #   * :label to override link text, otherwise based on the first resource name (translated)
      #   * :route to override automatically determining the default route
      #   * :match_path as an alternative way to control when the tab is active, /products would
      #     match /admin/products, /admin/products/5/variants etc.  Can be a String or a Regexp.
      #     Controller names are ignored if :match_path is provided.
      #
      # Example:
      #   # Link to /admin/orders, also highlight tab for ProductsController and ShipmentsController
      #   tab :orders, :products, :shipments

      ICON_SIZE = 16

      def tab(*args)
        options = { label: args.first.to_s }

        # Return if resource is found and user is not allowed to :admin
        return '' if (klass = klass_for(args.first.to_s)) && cannot?(:admin, klass)

        options = options.merge(args.pop) if args.last.is_a?(Hash)
        options[:route] ||= "admin_#{args.first}"

        destination_url = options[:url] || spree.send("#{options[:route]}_path")

        if options[:do_not_titleize] == true
          titleized_label = options[:label]
        else
          titleized_label = Spree.t(options[:label], default: options[:label], scope: [:admin, :tab]).titleize
        end

        css_classes = ['sidebar-menu-item d-block w-100 position-relative']

        selected = if options[:match_path].is_a? Regexp
                     request.fullpath =~ options[:match_path]
                   elsif options[:match_path]
                     request.fullpath.starts_with?("#{spree.admin_path}#{options[:match_path]}")
                   else
                     args.include?(controller.controller_name.to_sym)
                   end

        link = if options[:icon]
                 link_to_with_icon(
                   options[:icon],
                   titleized_label,
                   destination_url,
                   class: 'w-100 p-3 d-flex align-items-center'
                 )
               else
                 link_to(
                   titleized_label,
                   destination_url,
                   class: "sidebar-submenu-item w-100 py-2 py-md-1 pl-3 d-block #{'text-success' if selected}"
                 )
               end

        css_classes << 'selected' if selected

        css_classes << options[:css_class] if options[:css_class]
        content_tag('li', link, class: css_classes.join(' '))
      end

      # Single main menu item
      def main_menu_item(text, url: nil, icon: nil)
        link_to url, 'data-toggle': 'collapse', class: 'd-flex w-100 p-3 position-relative align-items-center' do
          if icon.ends_with?('.svg')
            svg_icon(name: icon, classes: 'mr-2', width: ICON_SIZE, height: ICON_SIZE) +
              content_tag(:span, " #{text}", class: 'text') +
              svg_icon(name: 'chevron-left.svg', classes: 'drop-menu-indicator position-absolute', width: (ICON_SIZE - 4), height: (ICON_SIZE - 4))
          else
            content_tag(:span, nil, class: "icon icon-#{icon} mr-2") +
              content_tag(:span, " #{text}", class: 'text') +
              svg_icon(name: 'chevron-left.svg', classes: 'drop-menu-indicator position-absolute', width: (ICON_SIZE - 4), height: (ICON_SIZE - 4))
          end
        end
      end

      # Main menu tree menu
      def main_menu_tree(text, icon: nil, sub_menu: nil, url: '#')
        content_tag :li, class: 'sidebar-menu-item d-block w-100' do
          main_menu_item(text, url: url, icon: icon) +
            render(partial: "spree/admin/shared/sub_menu/#{sub_menu}")
        end
      end

      # the per_page_dropdown is used on index pages like orders, products, promotions etc.
      # this method generates the select_tag
      def per_page_dropdown
        # there is a config setting for admin_products_per_page, only for the orders page
        if @products && per_page_default = Spree::Backend::Config.admin_products_per_page
          per_page_options = []
          5.times do |amount|
            per_page_options << (amount + 1) * Spree::Backend::Config.admin_products_per_page
          end
        else
          per_page_default = Spree::Backend::Config.admin_orders_per_page
          per_page_options = %w{25 50 75}
        end

        selected_option = params[:per_page].try(:to_i) || per_page_default

        select_tag(:per_page,
                   options_for_select(per_page_options, selected_option),
                   class: "w-auto form-control js-per-page-select per-page-selected-#{selected_option} custom-select")
      end

      # helper method to create proper url to apply per page ing
      # fixes https://github.com/spree/spree/issues/6888
      def per_page_dropdown_params(args = nil)
        args = params.permit!.to_h.clone
        args.delete(:page)
        args.delete(:per_page)
        args
      end

      # finds class for a given symbol / string
      #
      # Example :
      # :products returns Spree::Product
      # :my_products returns MyProduct if MyProduct is defined
      # :my_products returns My::Product if My::Product is defined
      # if cannot constantize it returns nil
      # This will allow us to use cancan abilities on tab
      def klass_for(name)
        model_name = name.to_s

        ["Spree::#{model_name.classify}", model_name.classify, model_name.tr('_', '/').classify].find(&:safe_constantize).try(:safe_constantize)
      end

      def link_to_clone(resource, options = {})
        options[:data] = { action: 'clone', 'original-title': Spree.t(:clone) }
        options[:class] = 'btn btn-warning btn-sm with-tip'
        options[:method] = :post
        options[:icon] = 'clone.svg'
        button_link_to '', clone_object_url(resource), options
      end

      def link_to_clone_promotion(promotion, options = {})
        options[:data] = { action: 'clone', 'original-title': Spree.t(:clone) }
        options[:class] = 'btn btn-warning btn-sm with-tip'
        options[:method] = :post
        options[:icon] = 'clone.svg'
        button_link_to '', clone_admin_promotion_path(promotion), options
      end

      def link_to_edit(resource, options = {})
        url = options[:url] || edit_object_url(resource)
        options[:data] = { action: 'edit' }
        options[:class] = 'btn btn-primary btn-sm'
        link_to_with_icon('edit.svg', Spree.t(:edit), url, options)
      end

      def link_to_edit_url(url, options = {})
        options[:data] = { action: 'edit' }
        options[:class] = 'btn btn-primary btn-sm'
        link_to_with_icon('edit.svg', Spree.t(:edit), url, options)
      end

      def link_to_delete(resource, options = {})
        url = options[:url] || object_url(resource)
        name = options[:name] || Spree.t(:delete)
        options[:class] = 'btn btn-danger btn-sm delete-resource'
        options[:data] = { confirm: Spree.t(:are_you_sure), action: 'remove' }
        link_to_with_icon 'delete.svg', name, url, options
      end

      def link_to_with_icon(icon_name, text, url, options = {})
        options[:class] = (options[:class].to_s + " icon-link with-tip action-#{icon_name}").strip
        options[:title] = text if options[:no_text]
        text = options[:no_text] ? '' : content_tag(:span, text, class: 'text')
        options.delete(:no_text)
        if icon_name
          icon = if icon_name.ends_with?('.svg')
                   svg_icon(name: icon_name, classes: "#{'mr-2' unless text.empty?} icon icon-#{icon_name}", width: ICON_SIZE, height: ICON_SIZE)
                 else
                   content_tag(:span, '', class: "#{'mr-2' unless text.empty?} icon icon-#{icon_name}")
                 end
          text = "#{icon} #{text}"
        end
        link_to(text.html_safe, url, options)
      end

      def spree_icon(icon_name)
        if icon_name.ends_with?('.svg')
          icon_name ? svg_icon(name: icon_name, classes: icon_name, width: ICON_SIZE, height: ICON_SIZE) : ''
        else
          icon_name ? content_tag(:span, '', class: icon_name) : ''
        end
      end

      # Override: Add disable_with option to prevent multiple request on consecutive clicks
      def button(text, icon_name = nil, button_type = 'submit', options = {})
        if icon_name
          icon = if icon_name.ends_with?('.svg')
                   svg_icon(name: icon_name, classes: "icon icon-#{icon_name}", width: ICON_SIZE, height: ICON_SIZE)
                 else
                   content_tag(:span, '', class: "icon icon-#{icon_name}")
                 end
          text = "#{icon} #{text}"
        end

        css_classes = options[:class] || 'btn-primary'
        button_tag(
          text.html_safe,
          options.merge(
            type: button_type,
            class: "btn #{css_classes}",
            'data-disable-with' => "#{Spree.t(:saving)}..."
          )
        )
      end

      def button_link_to(text, url, html_options = {})
        if html_options[:method] &&
            !html_options[:method].to_s.casecmp('get').zero? &&
            !html_options[:remote]
          form_tag(url, method: html_options.delete(:method)) do
            button(text, html_options.delete(:icon), nil, html_options)
          end
        else
          if html_options['data-update'].nil? && html_options[:remote]
            object_name, action = url.split('/')[-2..-1]
            html_options['data-update'] = [action, object_name.singularize].join('_')
          end

          html_options.delete('data-update') unless html_options['data-update']

          html_options[:class] = html_options[:class] ? "btn #{html_options[:class]}" : 'btn btn-outline-secondary'

          if html_options[:icon]
            icon = if html_options[:icon].ends_with?('.svg')
                     svg_icon(name: html_options[:icon], classes: "icon icon-#{html_options[:icon]}", width: ICON_SIZE, height: ICON_SIZE)
                   else
                     content_tag(:span, '', class: "icon icon-#{html_options[:icon]}")
                   end
            text = "#{icon} #{text}"
          end

          link_to(text.html_safe, url, html_options.except(:icon))
        end
      end

      def configurations_sidebar_menu_item(link_text, url, options = {})
        is_selected = url.ends_with?(controller.controller_name) ||
          url.ends_with?("#{controller.controller_name}/edit") ||
          url.ends_with?("#{controller.controller_name.singularize}/edit")

        options[:class] = 'sidebar-menu-item d-block w-100'
        options[:class] << ' selected' if is_selected
        content_tag(:li, options) do
          link_to(link_text, url, class: "#{'text-success' if is_selected} sidebar-submenu-item w-100 py-2 py-md-1 pl-3 d-block")
        end
      end

      def active_badge(condition, options = {})
        label = options[:label]
        label ||= condition ? Spree.t(:say_yes) : Spree.t(:say_no)
        css_class = condition ? 'badge-active' : 'badge-inactive'

        content_tag(:strong, class: "badge #{css_class} text-uppercase") do
          label
        end
      end

      def main_part_classes
        ActiveSupport::Deprecation.warn(<<-DEPRECATION, caller)
          Admin::NavigationHelper#main_part_classes is deprecated and will be removed in Spree 5.0.
        DEPRECATION
        if cookies['sidebar-minimized'] == 'true'
          'col-12 sidebar-collapsed'
        else
          'col-9 offset-3 col-md-10 offset-md-2'
        end
      end

      def main_sidebar_classes
        ActiveSupport::Deprecation.warn(<<-DEPRECATION, caller)
          Admin::NavigationHelper#main_sidebar_classes is deprecated and will be removed in Spree 5.0.
        DEPRECATION
        if cookies['sidebar-minimized'] == 'true'
          'col-3 col-md-2 sidebar'
        else
          'p-0 col-3 col-md-2 sidebar'
        end
      end

      def wrapper_classes
        ActiveSupport::Deprecation.warn(<<-DEPRECATION, caller)
          Admin::NavigationHelper#wrapper_classes is deprecated and will be removed in Spree 5.0.
        DEPRECATION
        'sidebar-minimized' if cookies['sidebar-minimized'] == 'true'
      end
    end
  end
end
