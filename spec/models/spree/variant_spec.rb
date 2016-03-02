module Spree
  describe Variant, type: :model do
    context "filter assemblies" do
      let(:mug) { create(:product) }
      let(:mug_master) { mug.master }
      let(:tshirt) { create(:product) }
      let(:tshirt_master) { tshirt.master }
      let(:variant) { create(:variant) }

      context "variant has more than one assembly" do
        before { variant.assemblies.push [mug_master, tshirt_master] }

        it "returns both products" do
          expect(variant.assemblies_for([mug_master, tshirt_master])).to include mug_master
          expect(variant.assemblies_for([mug_master, tshirt_master])).to include tshirt_master
        end

        it { expect(variant).to be_a_part }
      end

      context "variant no assembly" do
        it "returns both products" do
          expect(variant.assemblies_for([mug_master, tshirt_master])).to be_empty
        end
      end
    end
  end
end
