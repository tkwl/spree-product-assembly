FactoryGirl.define do
  factory :assemblies_part, class: 'Spree::AssembliesPart' do
    assembly { build(:variant) }
    part { build(:variant) }
    count 1
    variant_selection_deferred false
  end
end
