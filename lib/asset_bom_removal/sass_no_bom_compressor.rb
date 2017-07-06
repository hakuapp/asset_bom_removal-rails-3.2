require 'sprockets/sass_compressor'

module AssetBomRemoval
  class SassNoBomCompressor < Sprockets::SassCompressor
    # Let the default sass processor do all the hard work
    def call(input)
      remove_bom_from_css(super(input))
    end

  private

    def remove_bom_from_css(css_string)
      if css_string.bytes[0..2] == [0xEF, 0xBB, 0xBF]
        css_string[3..-1]
      else
        css_string
      end
    end
  end
end
