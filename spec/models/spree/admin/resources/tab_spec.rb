require 'spec_helper'

module Spree
  module Admin
    describe Resources::Tab, type: :model do
      let(:tab) { described_class.new(icon_name, availability_check) }
      let(:icon_name) { 'cart-check.svg' }
      let(:availability_check) { nil }

      describe '#icon_name' do
        subject { tab.icon_name }

        it 'returns icon_name' do
          expect(subject).to eq(icon_name)
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
