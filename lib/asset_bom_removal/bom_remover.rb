module AssetBomRemoval
  class BomRemover
    def self.remove_bom(string)
      new(string).remove_bom
    end

    def initialize(string)
      @string = string
    end

    def remove_bom
      if string_contains_utf8_bom?
        string.dup.force_encoding('UTF-8').tap do |utf8_string|
          utf8_string.delete! "\xEF\xBB\xBF"
        end
      else
        string
      end
    end

    private

    attr_reader :string

    def string_contains_utf8_bom?
      with_encoding('UTF-8') do |utf8_string|
        utf8_string.to_s.include? "\xEF\xBB\xBF"
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
