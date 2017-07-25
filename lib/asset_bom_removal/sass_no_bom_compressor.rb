require 'sprockets/sass_compressor'
require 'asset_bom_removal/bom_remover'

module AssetBomRemoval
  class SassNoBomCompressor < Sprockets::SassCompressor
    # Let the default sass processor do all the hard work
    def call(input)
      BomRemover.remove_bom(super(input))
    end
  end
end
