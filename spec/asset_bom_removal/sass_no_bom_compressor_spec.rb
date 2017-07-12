require 'spec_helper'
require 'asset_bom_removal/sass_no_bom_compressor'
require 'sprockets/sass_compressor'

RSpec.describe AssetBomRemoval::SassNoBomCompressor do
  subject { described_class.instance }
  let(:sass_compressor) { Sprockets::SassCompressor.instance }
  let(:bom_bytes) { [0xEF, 0xBB, 0xBF] }

  describe '#call' do
    context 'when supplied with css that generates a BOM' do
      let(:input) { { data: File.read(fixture_file_path('will-generate-a-bom.css')) } }

      it 'strips the BOM from the compressed CSS' do
        default_version = sass_compressor.call(input)
        # confirm our expectations that the sass compressor will generate a BOM
        expect(default_version.bytes.take(3)).to eq(bom_bytes)

        no_bom_version = subject.call(input)
        expect(no_bom_version.bytes.take(3)).not_to eq(bom_bytes)
      end
    end

    context 'when supplied with css that does not generate a BOM' do
      let(:input) { { data: File.read(fixture_file_path('wont-generate-a-bom.css')) } }

      it 'leaves the compressed CSS as-is' do
        default_version = sass_compressor.call(input)
        # confirm our expectations that the sass compressor wont generate a BOM
        expect(default_version.bytes.take(3)).not_to eq(bom_bytes)

        no_bom_version = subject.call(input)
        expect(no_bom_version.bytes).to eq(default_version.bytes)
      end
    end
  end
end
