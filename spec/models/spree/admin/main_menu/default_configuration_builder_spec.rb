require 'spec_helper'

module Spree
  module Admin
    describe MainMenu::DefaultConfigurationBuilder, type: :model do
      let(:builder) { described_class.new }

      describe '#build' do
        subject { builder.build }

        it 'builds a valid menu' do
          expect(subject.items.count).to eq(12)
          expect(subject.items.map(&:key)).to include('dashboard')
          expect(subject.items.map(&:key)).to include('orders')
          expect(subject.items.map(&:key)).to include('settings')
        end
      end
    end
  end
end
