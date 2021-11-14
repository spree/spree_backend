module Spree
  module Admin
    module DigitalHelper
      def asset_icon(asset)
        file_name = case asset.attachment.content_type
                    when /pdf\z/
                      'file-earmark-pdf.svg'
                    when /\Aimage/
                      'file-earmark-image.svg'
                    when /zip\z/
                      'file-earmark-zip.svg'
                    when 'text/csv', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                      'file-earmark-spreadsheet.svg'
                    when /\Avideo/
                      'file-earmark-play.svg'
                    when /\Aaudio/
                      'file-earmark-music.svg'
                    when /\Afont/
                      'file-earmark-font.svg'
                    else
                      'file-earmark.svg'
                    end

        svg_icon name: file_name, width: 50, height: 50
      end
    end
  end
end
