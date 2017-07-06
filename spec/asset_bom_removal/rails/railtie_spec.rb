require 'spec_helper'
require 'rails/railtie'
require 'asset_bom_removal/rails/railtie'
require 'asset_bom_removal/sass_no_bom_compressor'

RSpec.describe AssetBomRemoval::Rails::Railtie do
  subject { described_class.instance }

  describe '#sass_might_output_bom?' do
    let(:sass_config) { double(:sass_config) }
    let(:app_config) { double(:config, sass: sass_config) }
    let(:app) { double(:app, config: app_config) }
    let(:rails_env) { double(:rails_env) }
    before { allow(Rails).to receive(:env).and_return(rails_env) }

    it 'is true if Rails.env is production' do
      allow(rails_env).to receive(:production?).and_return(true)
      expect(subject.sass_might_output_bom?(app)).to be_truthy
    end

    it 'is true if the app is configured to use :compressed sass style' do
      allow(rails_env).to receive(:production?).and_return(false)
      allow(sass_config).to receive(:style).and_return(:compressed)
      expect(subject.sass_might_output_bom?(app)).to be_truthy
    end

    it 'is false otherwise' do
      allow(rails_env).to receive(:production?).and_return(false)
      allow(sass_config).to receive(:style).and_return(:compact)
      expect(subject.sass_might_output_bom?(app)).to be_falsy
    end
  end

  describe '#app_uses_sass_for_css_compression?' do
    let(:assets_config) { {} }
    let(:app_config) { double(:config, assets: assets_config) }
    let(:app) { double(:app, config: app_config) }

    it 'is false if the app is configured to use something other than sass or scss as a css_compressor' do
      assets_config[:css_compressor] = :yui
      expect(subject.app_uses_sass_for_css_compression?(app)).to be_falsy
    end

    it 'is true if the app is configured to use sass as a css_compressor' do
      assets_config[:css_compressor] = :sass
      expect(subject.app_uses_sass_for_css_compression?(app)).to be_truthy
    end

    it 'is true if the app is configured to use scss as a css_compressor' do
      assets_config[:css_compressor] = :scss
      expect(subject.app_uses_sass_for_css_compression?(app)).to be_truthy
    end

    # this because a nil compressor becomes sass in production mode by default
    it 'is true if the app is not configured to use a css_compressor' do
      assets_config[:css_compressor] = nil
      expect(subject.app_uses_sass_for_css_compression?(app)).to be_truthy
    end
  end

  describe '#setup_css_compression_with_bom_removal' do
    let(:assets_config) { double(:assets_config) }
    let(:app_config) { double(:app_config, assets: assets_config) }
    let(:app) { double(:app, config: app_config) }

    context 'when sass might output a bom' do
      before { allow(subject).to receive(:sass_might_output_bom?).and_return true }

      context 'and the app uses sass for compression' do
        before { allow(subject).to receive(:app_uses_sass_for_css_compression?).and_return true }

        it 'configures the assets config to use our css compressor' do
          expect(assets_config).to receive(:css_compressor=).with(AssetBomRemoval::SassNoBomCompressor)
          subject.setup_css_compression_with_bom_removal(app)
        end
      end

      context 'but the app does not use sass for compression' do
        before { allow(subject).to receive(:app_uses_sass_for_css_compression?).and_return false }

        it 'leaves the assets config alone' do
          expect(assets_config).not_to receive(:css_compressor=)
          subject.setup_css_compression_with_bom_removal(app)
        end
      end
    end

    context 'when sass will not output a bom' do
      before { allow(subject).to receive(:sass_might_output_bom?).and_return false }

      it 'leaves the assets config alone' do
        expect(assets_config).not_to receive(:css_compressor=)
        subject.setup_css_compression_with_bom_removal(app)
      end
    end
  end
end
