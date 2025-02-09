# spec/builders/bicycle_builder_spec.rb
require 'rails_helper'

RSpec.describe BicycleBuilder, type: :model do
  before(:all) do
    @catalog = Catalog.instance!

    # Create parts and options for the catalog.
    # For this test, we’ll use two parts: frame_type and wheels.
    @frame_part = @catalog.parts.create!(part_key: 'frame_type')
    @frame_part.part_options.create!(option: 'full-suspension', in_stock: true)
    @frame_part.part_options.create!(option: 'diamond', in_stock: true)

    @wheels_part = @catalog.parts.create!(part_key: 'wheels')
    @wheels_part.part_options.create!(option: 'mountain wheels', in_stock: true)
    @wheels_part.part_options.create!(option: 'road wheels', in_stock: true)

    # Ensure the builder loads after the catalog exists so that its dynamic setters are defined.
    load "#{Rails.root}/app/builders/bicycle_builder.rb"
  end

  after(:all) do
    PartOption.destroy_all
    Part.destroy_all
    Bicycle.destroy_all
    Catalog.destroy_all
  end

  describe "#build" do
    context "with a valid configuration" do
      let(:valid_input) do
        {
          frame_type: 'full-suspension',
          wheels: 'mountain wheels'
        }
      end

      it "creates a concrete Bicycle with the correct configuration" do
        builder = BicycleBuilder.new
        # The builder now has dynamically defined methods based on the catalog parts.
        builder.set_frame_type(valid_input[:frame_type])
        builder.set_wheels(valid_input[:wheels])

        bike = builder.build

        expect(bike).to be_persisted
        expect(bike.custom_product_parts.count).to eq(2)

        frame_bp = bike.custom_product_parts.find { |bp| bp.part.part_key == 'frame_type' }
        wheels_bp = bike.custom_product_parts.find { |bp| bp.part.part_key == 'wheels' }

        expect(frame_bp).not_to be_nil
        expect(frame_bp.part_option.option).to eq('full-suspension')
        expect(wheels_bp).not_to be_nil
        expect(wheels_bp.part_option.option).to eq('mountain wheels')
      end
    end

    context "with an invalid configuration" do
      it "raises an error when a selected option is not available" do
        builder = BicycleBuilder.new
        builder.set_frame_type('non-existent option')
        builder.set_wheels('mountain wheels')
        expect { builder.build }.to raise_error(StandardError, /out of stock/)
      end
    end
  end
end
