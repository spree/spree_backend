require 'spec_helper'
module Spree
  describe Spree::Admin::PromotionRulesHelper, type: :helper do
    it 'does not include existing rules in options' do
      promotion = build(:promotion)
      promotion.promotion_rules << Spree::Promotion::Rules::ItemTotal.new

      options = helper.options_for_promotion_rule_types(promotion)
      expect(options).not_to match(/ItemTotal/)
    end
  end
end
