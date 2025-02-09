class BicyclePart < ApplicationRecord
  belongs_to :bicycle
  belongs_to :part
  belongs_to :part_option
end
