class Bicycle < ApplicationRecord
  belongs_to :catalog, class_name: "Catalog", foreign_key: "catalog_id"
  has_many :bicycle_parts, dependent: :destroy

  def configuration
    bicycle_parts.includes(:part, :part_option).each_with_object({}) do |bicycle_part, hash|
      hash[bicycle_part.part.part_key.to_sym] = bicycle_part.part_option.option
    end
  end
end
