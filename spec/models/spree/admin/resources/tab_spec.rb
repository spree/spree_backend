require 'spec_helper'

module Spree
  module Admin
    describe Resources::Tab, type: :model do
      let(:tab) { described_class.new(icon_name, text, url, classes) }
      let(:icon_name) { 'cart-check.svg' }
      let(:text) { 'Cart' }
      let(:url) { '/cart' }
      let(:classes) { 'nav-link' }

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

      describe '#classes' do
        subject { tab.classes }

        it 'returns classes' do
          expect(subject).to eq(classes)
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

      describe '#active?' do
        subject { tab.active?(current_tab) }

        before { tab.with_active_check }

        context 'when tab matches the current tab' do
          let(:current_tab) { text }

          it "returns true" do
            expect(subject).to be(true)
          end
        end

        context 'when tab does not match the current tab' do
          let(:current_tab) { 'non-matching' }

          it "returns false" do
            expect(subject).to be(false)
          end
        end
      end

      describe '#complete?' do
        subject { tab.complete?(resource) }
        let(:resource) { double }

        context 'when complete check is not set' do
          it 'is returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when complete check returns true' do
          before do
            tab.with_completed_check
            allow(resource).to receive(:completed?).and_return(true)
          end

          it 'returns true' do
            expect(subject).to be(true)
          end
        end

        context 'when complete check returns false' do
          before do
            tab.with_completed_check
            allow(resource).to receive(:completed?).and_return(false)
          end

          it 'returns false' do
            expect(subject).to be(false)
          end
        end
      end
    end
  end
end
