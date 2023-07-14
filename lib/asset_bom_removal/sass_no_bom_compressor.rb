require 'sass/rails/compressor'
require 'asset_bom_removal/bom_remover'

module AssetBomRemoval
  class SassNoBomCompressor < Sass::Rails::CssCompressor
    # Let the default sass processor do all the hard work
    def compress(css)
      BomRemover.remove_bom(super(css))
    end
  end
end
