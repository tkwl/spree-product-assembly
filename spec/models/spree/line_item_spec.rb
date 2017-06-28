module Spree
  describe LineItem, type: :model do
    let!(:order) { create(:order_with_line_items) }
    let(:line_item) { order.line_items.first }
    let(:product) { line_item.product }
    let(:variant) { line_item.variant }
    let(:inventory) { double('order_inventory') }

    context "bundle parts stock" do
      let(:parts) { (1..2).map { create(:variant) } }

      before { product.master.parts << parts }

      context "one of them not in stock" do
        before do
          part = product.parts.first
          part.stock_items.update_all backorderable: false

          expect(part).not_to be_in_stock
        end

        it "doesn't save line item quantity" do
          expect { order.contents.add(variant, 10) }.to(
            raise_error ActiveRecord::RecordInvalid
          )
        end
      end

      context "in stock" do
        before do
          parts.each do |part|
            part.stock_items.first.set_count_on_hand(10)
          end
          expect(parts[0]).to be_in_stock
          expect(parts[1]).to be_in_stock
        end

        it "saves line item quantity" do
          line_item = order.contents.add(variant, 10)
          expect(line_item).to be_valid
        end
      end
    end

    context "updates bundle product line item" do
      let(:parts) { (1..2).map { create(:variant) } }

      before do
        product.master.parts << parts
        order.create_proposed_shipments
        order.finalize!
      end

      it "verifies inventory units via OrderInventoryAssembly" do
        expect(OrderInventoryAssembly).to receive(:new).
          with(line_item).
          and_return(inventory)
        expect(inventory).to receive(:verify).with(line_item.target_shipment)
        line_item.quantity = 2
        line_item.save
      end
    end

    context "updates regular line item" do
      it "verifies inventory units via OrderInventory" do
        expect(OrderInventory).to receive(:new).
          with(line_item.order, line_item).
          and_return(inventory)
        expect(inventory).to receive(:verify).with(line_item.target_shipment)
        line_item.quantity = 2
        line_item.save
      end
    end

    context "removing line items" do
      it "removes part line items" do
        line_item = create(:line_item)
        create(:part_line_item, line_item: line_item)

        line_item.destroy

        expect(Spree::PartLineItem.count).to eq 0
      end
    end
  end
end
