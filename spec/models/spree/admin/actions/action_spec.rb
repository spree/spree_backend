require 'spec_helper'

module Spree
  module Admin
    describe Actions::Action, type: :model do
      let(:action) { described_class.new(config) }
      let(:config) do
        {
          icon_name: 'cart-check.svg',
          key: 'Cart',
          url: '/cart',
          classes: 'nav-link',
          availability_checks: availability_checks,
          method: :put,
          id: 'admin_new_order',
          target: :blank,
          data: { turbo: false }
        }
      end
      let(:availability_checks) { [] }

      describe '#icon_name' do
        subject { action.icon_name }

        it 'returns icon_name' do
          expect(subject).to eq(config[:icon_name])
        end
      end

      describe '#key' do
        subject { action.key }

        it 'returns key' do
          expect(subject).to eq(config[:key])
        end
      end

      describe '#url' do
        subject { action.url }

        it 'returns url' do
          expect(subject).to eq(config[:url])
        end
      end

      describe '#classes' do
        subject { action.classes }

        it 'returns classes' do
          expect(subject).to eq(config[:classes])
        end
      end

      describe '#method' do
        subject { action.method }

        it 'returns method' do
          expect(subject).to eq(config[:method])
        end
      end

      describe '#id' do
        subject { action.id }

        it 'returns id' do
          expect(subject).to eq(config[:id])
        end
      end

      describe '#target' do
        subject { action.target }

        it 'returns target' do
          expect(subject).to eq(config[:target])
        end
      end

      describe '#data' do
        subject { action.data }

        it 'returns data' do
          expect(subject).to eq(config[:data])
        end
      end

      describe '#available?' do
        subject { action.available?(ability, resource) }

        let(:ability) { double }
        let(:resource) { double }

        context 'when availability checks were not set' do
          it 'is returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when all availability checks return true' do
          let(:availability_checks) do
            [->(_ability, _resource) { true }]
          end

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when at least one availability check returns false' do
          let(:availability_checks) do
            [->(_ability, _resource) { false }]
          end

          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end
    end
  end
end
