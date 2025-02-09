class BicycleBuilder
  attr_reader :parts_data

  def initialize
    @parts_data = {}
  end

  def method_missing(method, *args, &block)
    method_name = method.to_s
    if method_name.start_with?("set_")
      part_name = method_name.sub("set_", "").to_sym
      @parts_data[part_name] = args.first
      return self
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

    catalog = Catalog.instance!
    raise "Catalog not found" unless catalog

    bike = Bicycle.create!(name: "Bike #{Time.now.to_i}", catalog: catalog)

    @parts_data.each do |part_key, option_value|
      catalog_part = catalog.parts.find_by!(part_key: part_key.to_s)
      catalog_option = catalog_part.part_options.find_by!(option: option_value)
      bike.custom_product_parts.create!(part: catalog_part, part_option: catalog_option)
    end

    bike
  end
end
