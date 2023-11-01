require 'spec_helper'

module Spree
  module Admin
    describe Tabs::Tab, type: :model do
      let(:tab) { described_class.new(key, translation_key, url, icon_key, partial_name, availability_checks, active_check, data_hook) }

      let(:key) { 'cart' }
      let(:translation_key) { 'admin.cart' }
      let(:icon_key) { 'cart-check.svg' }
      let(:url) { '/cart' }
      let(:partial_name) { 'cart' }
      let(:check) { nil }
      let(:availability_checks) { [] }
      let(:active_check) { nil }
      let(:data_hook) { 'data_hook' }

      describe '#icon_key' do
        subject { tab.icon_key }

        it 'returns icon_key' do
          expect(subject).to eq(icon_key)
        end
      end

      describe '#key' do
        subject { tab.key }

        it 'returns key' do
          expect(subject).to eq(key)
        end
      end

      describe '#url' do
        subject { tab.url }

        it 'returns url' do
          expect(subject).to eq(url)
        end
      end

      describe '#label_translation_key' do
        subject { tab.label_translation_key }

        it 'returns text' do
          expect(subject).to eq(translation_key)
        end
      end

      describe '#data_hook' do
        subject { tab.data_hook }

        it 'returns classes' do
          expect(subject).to eq(data_hook)
        end
      end

      describe '#available?' do
        subject { tab.available?(ability, resource) }

        let(:ability) { double }
        let(:resource) { double }

        context 'when availability check is not set' do
          it 'is returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when availability check returns false' do
          let(:availability_checks) { [->(_ability, _resource) { false }] }

          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end

      describe '#active?' do
        subject { tab.active?('current_partial') }

        context 'when active check returns true' do
          let(:active_check) { ->(_current_tab, _text) { true } }

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when active check returns false' do
          let(:active_check) { ->(_current_tab, _text) { false } }

          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end
    end
  end
end
