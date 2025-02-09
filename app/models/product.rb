class Product < ApplicationRecord
  self.abstract_class = true

  has_many :parts, dependent: :destroy

  def parts_hash
    parts.each_with_object({}) do |part, hash|
      hash[part.part_key.to_sym] = part.part_options
    end
  end
end
