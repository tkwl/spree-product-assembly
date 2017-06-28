describe Spree::Product, type: :model do
  before do
    @product = create(:product, name: "Foo Bar")
    @master_variant = Spree::Variant.where(is_master: true).find_by_product_id(@product.id)
  end

  describe "Spree::Product Assembly" do
    before do
      @product = create(:product)
      @part1 = create(:product, can_be_part: true)
      @part2 = create(:product, can_be_part: true)

      create(:assemblies_part,
        assembly: @product.master,
        part: @part1.master,
        count: 1
      )
      create(:assemblies_part,
        assembly: @product.master,
        part: @part2.master,
        count: 4
      )
      @product.reload
    end

    it "is an assembly" do
      expect(@product).to be_assembly
    end

    it "cannot be part" do
      expect(@product).to be_assembly
      @product.can_be_part = true
      @product.valid?
      expect(@product.errors[:can_be_part]).to match_array ["assembly can't be part"]
    end
  end
end
