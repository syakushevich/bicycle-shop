class Part < ApplicationRecord
  belongs_to :catalog, class_name: "Catalog", foreign_key: "product_id"
  has_many :part_options, dependent: :destroy
end
