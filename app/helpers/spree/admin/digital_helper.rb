module Spree
  module Admin
    module DigitalHelper
      def asset_icon(asset)
        icon_size = 50

        case asset.attachment.content_type
        when 'application/pdf'
          svg_icon name: 'file-earmark-pdf.svg', width: icon_size, height: icon_size
        when 'image/png', 'image/jpeg', 'image/jpg', 'image/gif', 'image/bmp', 'image/tiff', 'image/svg+xml'
          svg_icon name: 'file-earmark-image.svg', width: icon_size, height: icon_size
        when 'application/zip', 'application/epub+zip', 'application/zip', 'application/gzip'
          svg_icon name: 'file-earmark-zip.svg', width: icon_size, height: icon_size
        when 'text/csv'
          svg_icon name: 'file-earmark-spreadsheet.svg', width: icon_size, height: icon_size
        when 'video/mpeg', 'video/webm', 'video/mp4', 'video/quicktime'
          svg_icon name: 'file-earmark-play.svg', width: icon_size, height: icon_size
        when 'audio/mp4', 'audio/mpeg', 'audio/ogg', 'audio/aac'
          svg_icon name: 'file-earmark-music.svg', width: icon_size, height: icon_size
        when 'font/otf', 'font/ttf', 'font/woff', 'font/woff2'
          svg_icon name: 'file-earmark-font.svg', width: icon_size, height: icon_size
        else
          svg_icon name: 'file-earmark.svg', width: icon_size, height: icon_size
        end
      end
    end
  end
end
