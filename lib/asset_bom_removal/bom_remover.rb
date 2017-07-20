module AssetBomRemoval
  class BomRemover
    def self.remove_bom(string)
      new(string).remove_bom
    end

    def initialize(string)
      @string = string
    end

    def remove_bom
      if string_starts_with_utf8_bom?
        string.dup.force_encoding('UTF-8').tap do |utf8_string|
          utf8_string.slice!(0)
        end
      else
        string
      end
    end

  private

    attr_reader :string

    def string_starts_with_utf8_bom?
      with_encoding('UTF-8') do |utf8_string|
        utf8_string[0] == "\xEF\xBB\xBF"
      end
    end

    def with_encoding(encoding)
      old_encoding = string.encoding
      begin
        return (yield string.force_encoding(encoding))
      ensure
        string.force_encoding(old_encoding)
      end
    end
  end
end
