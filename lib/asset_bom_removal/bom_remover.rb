module AssetBomRemoval
  module BomRemover
    def remove_bom(css_string)
      if css_string.bytes[0..2] == [0xEF, 0xBB, 0xBF]
        css_string.force_encoding('UTF-8')[1..-1]
      else
        css_string
      end
    end
    module_function :remove_bom
  end
end
