class BicycleBuilder
  attr_reader :parts_data

  def initialize
    @parts_data = {}
  end

  Catalog.instance.parts.pluck(:part_key).each do |part|
    define_method("set_#{part}") do |value|
      @parts_data[part.to_sym] = value
      self
    end
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
    catalog = Catalog.instance!
    raise "Catalog not found" unless catalog

    bike = Bicycle.create!(name: "Bike #{Time.now.to_i}", catalog: catalog)

    @parts_data.each do |part_key, option_value|
      catalog_part = catalog.parts.find_by!(part_key: part_key.to_s)
      catalog_option = catalog_part.part_options.find_by!(option: option_value)
      bike.bicycle_parts.create!(part: catalog_part, part_option: catalog_option)
    end

    bike
  end
end
