require 'spec_helper'

module Spree
  module Admin
    describe Tabs::Tab, type: :model do
      let(:tab) { described_class.new(config) }
      let(:config_base) do
        {
          icon_name: 'cart-check.svg',
          name: 'Cart',
          url: '/cart',
          classes: 'nav-link',
          partial_name: :cart
        }
      end
      let(:additional_config) { {} }
      let(:config) do
        config_base.merge(additional_config)
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

        context 'when availability check returns false' do
          let(:additional_config) do
            {
              availability_check: ->(_ability, _resource) { false }
            }
          end

          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end

      describe '#active?' do
        subject { tab.active?(current_tab) }

        context 'when active check returns true' do
          let(:additional_config) do
            {
              active_check: ->(_current_tab, _text) { true }
            }
          end
          let(:current_tab) { config[:partial_name] }

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when active check returns false' do
          let(:additional_config) do
            {
              active_check: ->(_current_tab, _text) { false }
            }
          end
          let(:current_tab) { 'non-matching' }

          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end

      describe '#complete?' do
        subject { tab.complete?(resource) }
        let(:resource) { double }

        context 'when complete check is not set' do
          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when complete check returns false' do
          let(:additional_config) do
            {
              completed_check: ->(_resource) { false }
            }
          end

          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end
    end
  end
end
