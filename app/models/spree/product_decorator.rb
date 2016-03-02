Spree::Product.class_eval do
  has_many :parts, through: :assemblies_parts
  has_many :assemblies_parts, through: :variants_including_master,
           source: :parts_variants

  scope :individual_saled, -> { where(individual_sale: true) }

  scope :search_can_be_part, ->(query){ not_deleted.available.joins(:master)
    .where(arel_table["name"].matches("%#{query}%").or(Spree::Variant.arel_table["sku"].matches("%#{query}%")))
    .where(can_be_part: true)
    .limit(30)
  }

  validate :assembly_cannot_be_part, if: :assembly?

  def variants_or_master
    has_variants? ? variants : [master]
  end

  def assembly?
    parts.present?
  end

  def count_of(variant)
    ap = assemblies_part(variant)
    # This checks persisted because the default count is 1
    ap.persisted? ? ap.count : 0
  end

  def assembly_cannot_be_part
    errors.add(:can_be_part, Spree.t(:assembly_cannot_be_part)) if can_be_part?
  end

  private
  def assemblies_part(variant)
    Spree::AssembliesPart.get(self.id, variant.id)
  end
end
