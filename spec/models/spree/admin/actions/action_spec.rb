require 'spec_helper'

module Spree
  module Admin
    describe Actions::Action, type: :model do
      let(:tab) { described_class.new(config) }
      let(:config) do
        {
          icon_name: 'cart-check.svg',
          name: 'Cart',
          url: '/cart',
          classes: 'nav-link'
        }
      end

      describe '#icon_name' do
        subject { tab.icon_name }

        it 'returns icon_name' do
          expect(subject).to eq(config[:icon_name])
        end
      end

      describe '#name' do
        subject { tab.name }

        it 'returns name' do
          expect(subject).to eq(config[:name])
        end
      end

      describe '#url' do
        subject { tab.url }

        it 'returns url' do
          expect(subject).to eq(config[:url])
        end
      end

      describe '#classes' do
        subject { tab.classes }

        it 'returns classes' do
          expect(subject).to eq(config[:classes])
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

        context 'when availability check returns true' do
          before do
            tab.with_availability_check(->(_ability, _resource) { true })
          end

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when availability check returns false' do
          before do
            tab.with_availability_check(->(_ability, _resource) { false })
          end

          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end
    end
  end
end
