require 'spec_helper'

module Spree
  module Admin
    describe CustomerReturnsController, type: :controller do
      stub_authorization!

      describe '#index' do
        subject do
          get :index, params: { order_id: customer_return.order.to_param }
        end

        let(:order)           { customer_return.order }
        let(:customer_return) { create(:customer_return) }

        it 'loads the order' do
          subject
          expect(assigns(:order)).to eq order
        end

        it 'loads the customer return' do
          subject
          expect(assigns(:customer_returns)).to include(customer_return)
        end

        context 'for different store' do
          let!(:new_store) { create(:store) }

          before { allow_any_instance_of(described_class).to receive(:current_store).and_return(new_store) }

          it 'should not load any orders' do
            expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
          end

          it 'should not load any customer returns' do
            expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end
      end

      describe '#new' do
        subject do
          get :new, params: { order_id: order.to_param }
        end

        let(:order) { create(:shipped_order, line_items_count: 1) }
        let!(:rma) { create :return_authorization, order: order, return_items: [create(:return_item, inventory_unit: order.inventory_units.first)] }

        before do
          create(:reimbursement_type, active: false) # inactive_reimbursement_type
          create(:reimbursement_type) # first_active_reimbursement_type
          create(:reimbursement_type) # second_active_reimbursement_type
        end

        it 'loads the order' do
          subject
          expect(assigns(:order)).to eq order
        end

        it 'creates a new customer return' do
          subject
          expect(assigns(:customer_return)).not_to be_persisted
        end

        context 'with previous customer return' do
          let(:order) { create(:shipped_order, line_items_count: 4) }
          let(:rma) { create(:return_authorization, order: order) }

          let!(:rma_return_item) { create(:return_item, return_authorization: rma, inventory_unit: order.inventory_units.first) }
          let!(:customer_return_return_item) { create(:return_item, return_authorization: rma, inventory_unit: order.inventory_units.last) }

          context 'there is a return item associated with an rma but not a customer return' do
            before do
              create(:customer_return_without_return_items, return_items: [customer_return_return_item]) # previous_customer_return
              subject
            end

            it 'loads the persisted rma return items' do
              expect(assigns(:rma_return_items).all?(&:persisted?)).to eq true
            end

            it 'has one rma return item' do
              expect(assigns(:rma_return_items)).to include(rma_return_item)
            end
          end
        end
      end

      describe '#edit' do
        subject do
          get :edit, params: { order_id: order.to_param, id: customer_return.to_param }
        end

        let(:order) { customer_return.order }
        let(:customer_return) { create(:customer_return, line_items_count: 3) }

        let!(:accepted_return_item) { customer_return.return_items.order('id').first.tap(&:accept!) }
        let!(:rejected_return_item) { customer_return.return_items.order('id').second.tap(&:reject!) }
        let!(:manual_intervention_return_item) { customer_return.return_items.order('id').third.tap(&:require_manual_intervention!) }

        before { subject }

        it 'loads the order' do
          expect(assigns(:order)).to eq order
        end

        it 'loads the customer return' do
          expect(assigns(:customer_return)).to eq customer_return
        end

        it 'loads the accepted return items' do
          expect(assigns(:accepted_return_items)).to eq [accepted_return_item]
        end

        it 'loads the rejected return items' do
          expect(assigns(:rejected_return_items)).to eq [rejected_return_item]
        end

        it 'loads the return items that require manual intervention' do
          expect(assigns(:manual_intervention_return_items)).to eq [manual_intervention_return_item]
        end

        it 'loads the return items that are still pending' do
          expect(assigns(:pending_return_items)).to eq []
        end

        it 'loads the reimbursements that are still pending' do
          expect(assigns(:pending_reimbursements)).to eq []
        end
      end

      describe '#create' do
        subject do
          post :create, params: customer_return_params
        end

        let(:current_store) { Spree::Store.default }
        let(:order) { create(:shipped_order, line_items_count: 1, store: current_store) }
        let!(:return_authorization) { create :return_authorization, order: order, return_items: [create(:return_item, inventory_unit: order.inventory_units.shipped.last)] }

        before { allow_any_instance_of(described_class).to receive(:current_store).and_return(current_store) }

        context 'valid customer return' do
          let(:stock_location) { order.shipments.last.stock_location }

          let(:customer_return_params) do
            {
              order_id: order.to_param,
              customer_return: {
                stock_location_id: stock_location.id,
                return_items_attributes: {
                  '0' => {
                    id: return_authorization.return_items.first.id,
                    returned: '1',
                    'pre_tax_amount' => '15.99',
                    inventory_unit_id: order.inventory_units.shipped.last.id
                  }
                }
              }
            }
          end

          it 'creates a customer return' do
            expect { subject }.to change { current_store.customer_returns.count }.by(1)
          end

          it 'redirects to the index page' do
            subject
            expect(response).to redirect_to(spree.edit_admin_order_customer_return_path(order, assigns(:customer_return)))
          end
        end

        context 'invalid customer return' do
          let(:customer_return_params) do
            {
              order_id: order.to_param,
              customer_return: {
                stock_location_id: '',
                return_items_attributes: {
                  '0' => {
                    returned: '1',
                    'pre_tax_amount' => '15.99',
                    inventory_unit_id: order.inventory_units.shipped.last.id
                  }
                }
              }
            }
          end

          it "doesn't create a customer return" do
            expect { subject }.not_to change { current_store.customer_returns.count }
          end

          it 'renders the new page' do
            subject
            expect(response).to render_template(:new)
          end
        end
      end
    end
  end
end
