class BicycleBuilder
  attr_reader :parts_data

  def initialize
    @parts_data = {}
  end

  # Instead of predefining setters from the catalog,
  # we'll use method_missing to handle any method starting with "set_"
  def method_missing(method, *args, &block)
    method_name = method.to_s
    if method_name.start_with?("set_")
      # Extract the part name (e.g., "frame_type" from "set_frame_type")
      part_name = method_name.sub("set_", "").to_sym
      @parts_data[part_name] = args.first
      self
    else
      super
    end
  end

  def respond_to_missing?(method, include_private = false)
    method.to_s.start_with?("set_") || super
  end

  def validate!
    errors = BicycleValidator.validate(@parts_data)
    unless errors.empty?
      messages = errors.values.flatten.join(', ')
      raise StandardError, messages
    end
  end

  def build
    validate!

    # Look up the catalog record using the singleton method.
    catalog = Catalog.instance!  # Assumes your catalog model is renamed to Catalog.
    raise "Catalog not found" unless catalog

    # Create the concrete bike. (No need to pass a 'type' attribute if not using STI here.)
    concrete_bike = Bicycle.create!(name: "Bike #{Time.now.to_i}", catalog: catalog)

    # For each configuration key in parts_data, find the matching catalog Part and PartOption,
    # then create a BicyclePart linking the concrete bike to that selection.
    @parts_data.each do |part_key, option_value|
      catalog_part = catalog.parts.find_by!(part_key: part_key.to_s)
      catalog_option = catalog_part.part_options.find_by!(option: option_value)
      concrete_bike.bicycle_parts.create!(part: catalog_part, part_option: catalog_option)
    end

    concrete_bike
  end
end
