require 'spec_helper'

module Spree
  module Admin
    describe MainMenu::SectionBuilder, type: :model do
      include Spree::TestingSupport::AuthorizationHelpers::CustomAbility

      subject { builder.build }

      let(:builder) { described_class.new(key, icon_key) }
      let(:key) { 'test-key' }
      let(:icon_key) { 'icon-key' }

      describe '#build' do
        it 'returns a section object that has the key set' do
          expect(subject.key).to eq(key)
        end

        it 'return a section object with label translation key set default to key' do
          expect(subject.label_translation_key).to eq(key)
        end

        it 'returns a section object with icon key set to icon key' do
          expect(subject.icon_key).to eq(icon_key)
        end

        it 'returns a section object without children' do
          expect(subject.items).to eq([])
        end

        describe '#with_label_translation_key' do
          before { builder.with_label_translation_key(label_translation_key) }

          let(:label_translation_key) { 'translation-key' }

          it 'returns a section object that has the key set' do
            expect(subject.key).to eq(key)
          end

          it 'return a section object with label translation key set default to key' do
            expect(subject.label_translation_key).to eq(label_translation_key)
          end

          it 'returns a section object with icon key set to icon key' do
            expect(subject.icon_key).to eq(icon_key)
          end
        end

        describe '#with_item' do
          before do
            builder.with_item(item1)
            builder.with_item(item2)
          end

          let(:key1) { 'key1' }
          let(:key2) { 'key2' }
          let(:item1) { double(key: key1) }
          let(:item2) { double(key: key2) }

          it 'returns a section object with items added' do
            expect(subject.items.count).to eq(2)
            expect(subject.items.map(&:key)).to eq(%w[key1 key2])
          end
        end

        describe '#with_items' do
          before do
            builder.with_items([item1, item2])
            builder.with_items([item3])
          end

          let(:key1) { 'key1' }
          let(:key2) { 'key2' }
          let(:key3) { 'key3' }
          let(:item1) { double(key: key1) }
          let(:item2) { double(key: key2) }
          let(:item3) { double(key: key3) }

          it 'returns a section object with items added' do
            expect(subject.items.count).to eq(3)
            expect(subject.items.map(&:key)).to eq(%w[key1 key2 key3])
          end
        end

        describe '#with_admin_ability_check' do
          before do
            builder.with_admin_ability_check(Spree::Taxon, Spree::Product)
          end

          let(:ability_class) { build_ability(&ability_block) }
          let(:ability) { ability_class.new(nil) }
          let(:store) { double }

          context 'when the user has admin access to one of the resources' do
            let(:ability_block) do
              proc { |_u| can :admin, Spree::Taxon }
            end

            it 'returns creates a section that\'s available for that role' do
              expect(subject.available?(ability, store)).to eq(true)
            end
          end

          context 'when the user has admin access to another of the resources' do
            let(:ability_block) do
              proc { |_u| can :admin, Spree::Product }
            end

            it 'returns creates a section that\'s available for that role' do
              expect(subject.available?(ability, store)).to eq(true)
            end
          end

          context 'when the user has only read access to one of the resources' do
            let(:ability_block) do
              proc { |_u| can :read, Spree::Product }
            end

            it 'returns creates a section that\'s available for that role' do
              expect(subject.available?(ability, store)).to eq(false)
            end
          end
        end

        describe '#with_manage_ability_check' do
          before do
            builder.with_manage_ability_check(Spree::Taxon, Spree::Product)
          end

          let(:ability_class) { build_ability(&ability_block) }
          let(:ability) { ability_class.new(nil) }
          let(:store) { double }

          context 'when the user has manage access to one of the resources' do
            let(:ability_block) do
              proc { |_u| can :manage, Spree::Taxon }
            end

            it 'returns creates a section that\'s available for that role' do
              expect(subject.available?(ability, store)).to eq(true)
            end
          end

          context 'when the user has manage access to another of the resources' do
            let(:ability_block) do
              proc { |_u| can :manage, Spree::Product }
            end

            it 'returns creates a section that\'s available for that role' do
              expect(subject.available?(ability, store)).to eq(true)
            end
          end

          context 'when the user has only admin access to one of the resources' do
            let(:ability_block) do
              proc { |_u| can :admin, Spree::Product }
            end

            it 'returns creates a section that\'s available for that role' do
              expect(subject.available?(ability, store)).to eq(false)
            end
          end
        end

      end
    end
  end
end
