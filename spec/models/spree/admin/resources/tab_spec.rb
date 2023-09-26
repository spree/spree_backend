require 'spec_helper'

module Spree
  module Admin
    describe Resources::Tab, type: :model do
      let(:tab) { described_class.new(icon_name, text, url, partial_name, classes, availability_check) }
      let(:icon_name) { 'cart-check.svg' }
      let(:text) { 'Cart' }
      let(:url) { '/cart' }
      let(:partial_name) { 'Cart' }
      let(:classes) do
        { class: 'nav-link active' }
      end
      let(:availability_check) { nil }

      describe '#icon_name' do
        subject { tab.icon_name }

        it 'returns icon_name' do
          expect(subject).to eq(icon_name)
        end
      end

      describe '#text' do
        subject { tab.text }

        it 'returns text' do
          expect(subject).to eq(text)
        end
      end

      describe '#url' do
        subject { tab.url }

        it 'returns url' do
          expect(subject).to eq(url)
        end
      end

      # TO-DO: If partial names would match the contents of 'text' - this can be removed.
      # For example, there's only one mismatch in _orders_tabs partial, and it's
      # :customer_details not matching :customer
      describe '#partial_name' do
        subject { tab.partial_name }

        it 'returns partial_name' do
          expect(subject).to eq(partial_name)
        end
      end

      describe '#classes' do
        subject { tab.classes }

        it 'returns classes' do
          expect(subject).to eq(classes)
        end
      end
      
      describe '#available?' do
        subject { tab.available?(ability, store) }

        let(:ability) { double }
        let(:store) { double }

        context 'when availability check is not set' do
          it 'is returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when availability check returns true' do
          let(:availability_check) { ->(_ability, _store) { true } }

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when availability check returns false' do
          let(:availability_check) { ->(_ability, _store) { false } }

          it 'returns true' do
            expect(subject).to be(false)
          end
        end
      end
    end
  end
end
