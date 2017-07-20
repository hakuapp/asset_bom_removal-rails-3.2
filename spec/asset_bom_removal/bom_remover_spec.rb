require 'spec_helper'
require 'asset_bom_removal/bom_remover'

RSpec.describe AssetBomRemoval::BomRemover do
  subject { described_class }

  let(:bom) { "\xEF\xBB\xBF" }

  shared_examples "removing the BOM from the string" do
    let(:stripped_string) { subject.remove_bom(example_string_with_bom) }

    it 'removes the BOM from the string' do
      expect(stripped_string.bytes[0..3]).not_to eq bom.bytes
    end

    it 'otherwise leaves the string alone' do
      expect(stripped_string.bytes).to eq example_string_without_bom.bytes
    end

    it 'returns the string encoded as utf-8' do
      expect(stripped_string.encoding).to eq Encoding::UTF_8
    end
  end

  context 'for a utf-8 string with the bom and ascii characters' do
    let(:example_string_with_bom) { "#{bom}hello" }
    let(:example_string_without_bom) { "hello" }

    include_examples "removing the BOM from the string"
  end

  context 'for a utf-8 string with the bom and utf-8 characters' do
    let(:example_string_with_bom) { "#{bom}Ⓗ∈llo" }
    let(:example_string_without_bom) { "Ⓗ∈llo" }

    include_examples "removing the BOM from the string"
  end

  context 'for an ascii string with the bom and ascii characters' do
    # this lets us test for strange encoding quirks
    let(:example_string_with_bom) { "#{bom}hello".force_encoding('ascii-8bit') }
    let(:example_string_without_bom) { "hello" }

    include_examples "removing the BOM from the string"
  end

  context 'for an ascii string with the bom and utf-8 characters' do
    # this lets us test for strange encoding quirks
    let(:example_string_with_bom) { "#{bom}Ⓗ∈llo".force_encoding('ascii-8bit') }
    let(:example_string_without_bom) { "Ⓗ∈llo" }

    include_examples "removing the BOM from the string"
  end

  shared_examples "leaving an un-BOM-ified string alone" do
    let(:stripped_string) { subject.remove_bom(example_string_without_bom) }

    it 'leaves the string alone' do
      expect(stripped_string.bytes).to eq example_string_without_bom.bytes
    end

    it 'returns the string encoded as it was' do
      expect(stripped_string.encoding).to eq example_string_without_bom.encoding
    end
  end

  context 'for a utf-8 string without the bom and ascii characters' do
    let(:example_string_without_bom) { "hello" }

    include_examples "leaving an un-BOM-ified string alone"
  end

  context 'for a utf-8 string without the bom and utf-8 characters' do
    let(:example_string_without_bom) { "Ⓗ∈llo" }

    include_examples "leaving an un-BOM-ified string alone"
  end

  context 'for an ascii string without the bom and ascii characters' do
    # this lets us test for strange encoding quirks
    let(:example_string_without_bom) { "hello".force_encoding('ascii-8bit') }

    include_examples "leaving an un-BOM-ified string alone"
  end

  context 'for an ascii string without the bom and utf-8 characters' do
    # this lets us test for strange encoding quirks
    let(:example_string_without_bom) { "Ⓗ∈llo".force_encoding('ascii-8bit') }

    include_examples "leaving an un-BOM-ified string alone"
  end
end
