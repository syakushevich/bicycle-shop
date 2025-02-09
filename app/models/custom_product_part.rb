class CustomProductPart < ApplicationRecord
  belongs_to :custom_product
  belongs_to :part
  belongs_to :part_option
end
