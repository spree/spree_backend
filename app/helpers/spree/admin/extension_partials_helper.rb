module Spree
  module Admin
    module ExtensionPartialsHelper
      def render_matching(pattern:nil, locals: {})
        old_path = Dir.pwd
        rendered = ''
        return rendered if pattern.nil?

        view_paths.paths.each do |view_path|
          Dir.chdir(view_path)
          result = Dir['spree/admin/extension/**/*'].select do |path|
            !File.directory?(path) && File.basename(path, '.html.erb') =~ /^_.+/
          end

          result.map! { |path| path.gsub(File.basename(path), File.basename(path, '.html.erb')[1..-1]) }
          result.each do |path|
            if path.match(/.+\/#{pattern}\/.+/)
              rendered += render partial: path, locals: locals
            end
          end
        end
        Dir.chdir(old_path)
        rendered
      end
    end
  end
end
