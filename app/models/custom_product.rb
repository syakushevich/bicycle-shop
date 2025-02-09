class CustomProduct < ApplicationRecord
  # This table is custom_products.
  # It holds all concrete (user‑customized) products.
  belongs_to :catalog, class_name: "Catalog", foreign_key: "catalog_product_id"
  has_many :custom_product_parts, dependent: :destroy

  def configuration
    custom_product_parts.includes(:part, :part_option).each_with_object({}) do |cpp, hash|
      hash[cpp.part.part_key.to_sym] = cpp.part_option.option
    end
  end
end
