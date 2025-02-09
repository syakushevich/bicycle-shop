require 'rails_helper'

RSpec.describe BicycleValidator, type: :model do
  before(:all) do
    @catalog = Catalog.instance!

    # Create parts and options.
    catalog_data = {
      frame_type:   ["full-suspension", "diamond", "step-through"],
      frame_finish: ["matte", "shiny"],
      wheels:       ["mountain wheels", "road wheels", "fat bike wheels"],
      rim_color:    ["black", "red", "blue"],
      chain:        ["8-speed chain", "single-speed chain"]
    }

    catalog_data.each do |part_key, options|
      part = @catalog.parts.create!(part_key: part_key.to_s)
      options.each do |opt|
        part.part_options.create!(option: opt, in_stock: true)
      end
    end
  end

  after(:all) do
    PartOption.destroy_all
    Part.destroy_all
    Bicycle.destroy_all
    Catalog.instance.destroy
  end

  context "when the configuration is valid" do
    let(:valid_input) do
      {
        frame_type: "full-suspension",
        frame_finish: "matte",
        wheels: "mountain wheels",
        rim_color: "black",
        chain: "8-speed chain"
      }
    end

    it "returns an empty errors hash" do
      expect(BicycleValidator.validate(valid_input)).to eq({})
    end
  end

  context "when the configuration violates custom rules" do
    let(:invalid_input) do
      {
        frame_type: "diamond",         # diamond is valid in isolation,
        frame_finish: "matte",
        wheels: "mountain wheels",     # but mountain wheels require a full-suspension frame.
        rim_color: "black",
        chain: "8-speed chain"
      }
    end

    it "returns an error for wheels" do
      errors = BicycleValidator.validate(invalid_input)
      expect(errors[:wheels]).to include("requires a full-suspension frame when using mountain wheels")
    end
  end

  context "when a selected option is out of stock" do
    before do
      # Mark the 'diamond' option for frame_type as out of stock.
      frame_type_part = @catalog.parts.find_by!(part_key: "frame_type")
      diamond_option = frame_type_part.part_options.find_by!(option: "diamond")
      diamond_option.update!(in_stock: false)
    end

    let(:out_of_stock_input) do
      {
        frame_type: "diamond",         # now out-of-stock.
        frame_finish: "matte",
        wheels: "road wheels",
        rim_color: "black",
        chain: "8-speed chain"
      }
    end

    it "returns an error for frame_type" do
      errors = BicycleValidator.validate(out_of_stock_input)
      expect(errors[:frame_type]).to include("selected frame type 'diamond' is out of stock")
    end
  end
end
