require 'spec_helper'

module Spree
  module Admin
    describe Actions::OrderDefaultActionsBuilder, type: :model do
      let(:builder) { described_class.new }
      let(:default_actions) do
        [:approve,
         :cancel,
         :resume,
         :resend,
         'admin.digitals.reset_download_links']
      end

      describe '#build' do
        subject { builder.build }

        it 'builds default tabs' do
          expect(subject.items.map(&:name)).to match(default_actions)
        end
      end
    end
  end
end
