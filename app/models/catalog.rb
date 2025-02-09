class Catalog < Product
  self.table_name = 'products'

  has_many :parts, foreign_key: "product_id", dependent: :destroy
  has_many :bicycles, foreign_key: "catalog_id", class_name: "Bicycle"

  before_validation :set_type

  def self.instance
    where(name: 'Catalog', type: sti_name).first
  end

  # Return the catalog, or create it if it does not exist.
  def self.instance!
    instance || create!(name: 'Catalog', type: sti_name)
  end

  def self.sti_name
    "Catalog"
  end

  private

  def set_type
    self.type ||= self.class.sti_name
  end
end
