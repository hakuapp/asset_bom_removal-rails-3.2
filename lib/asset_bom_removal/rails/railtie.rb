require 'asset_bom_removal/sass_no_bom_compressor'

module AssetBomRemoval
  module Rails
    class Railtie < ::Rails::Railtie
      def sass_might_output_bom?(app)
        ::Rails.env.production? || app.config.assets.compress
      end

      def app_uses_sass_for_css_compression?(app)
        # if css_compressor is not already set, it will be set to sass by
        # sass-rails
        css_compressor = (app.config.assets.fetch(:css_compressor, nil) || :sass)
        [:sass, :scss].include? css_compressor.to_sym
      end

      def setup_css_compression_with_bom_removal(app)
        if sass_might_output_bom?(app)
          # We only need to do this if sass will be using :compressed style
          # because other styles don't output a BOM
          if app_uses_sass_for_css_compression?(app)
            app.config.assets.css_compressor = AssetBomRemoval::SassNoBomCompressor.new
          end
        end
      end

      initializer :setup_css_compression_with_bom_removal, group: :all do |app|
        setup_css_compression_with_bom_removal(app)
      end
    end
  end
end
