require 'spec_helper'

module Spree
  module Admin
    describe Actions::Action, type: :model do
      let(:action) do
        described_class.new(
          key,
          label_translation_key,
          url,
          icon_key,
          style,
          availability_checks,
          additional_classes,
          method,
          id,
          target,
          data_attributes
        )
      end

      let(:key) { 'new_order' }
      let(:label_translation_key) { 'new_order' }
      let(:url) { '/admin/orders/new' }
      let(:icon_key) { 'add.svg' }
      let(:style) { ::Spree::Admin::Actions::ActionStyle::PRIMARY }
      let(:availability_checks) { [] }
      let(:additional_classes) { 'additional-class' }
      let(:method) { :put }
      let(:id) { 'new_order_button' }
      let(:target) { '_blank' }
      let(:data_attributes) { { turbo: false } }

      describe '#icon_key' do
        subject { action.icon_key }

        it 'returns icon_key' do
          expect(subject).to eq(icon_key)
        end
      end

      describe '#key' do
        subject { action.key }

        it 'returns key' do
          expect(subject).to eq(key)
        end
      end

      describe '#url' do
        subject { action.url }

        it 'returns url' do
          expect(subject).to eq(url)
        end
      end

      describe '#classes' do
        subject { action.classes }

        it 'returns style classes and additional classes' do
          expect(subject).to eq('btn-primary additional-class')
        end
      end

      describe '#method' do
        subject { action.method }

        it 'returns method' do
          expect(subject).to eq(method)
        end
      end

      describe '#id' do
        subject { action.id }

        it 'returns id' do
          expect(subject).to eq(id)
        end
      end

      describe '#target' do
        subject { action.target }

        it 'returns target' do
          expect(subject).to eq(target)
        end
      end

      describe '#data' do
        subject { action.data_attributes }

        it 'returns data' do
          expect(subject).to eq(data_attributes)
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
