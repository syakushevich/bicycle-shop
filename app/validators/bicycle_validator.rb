class BicycleValidator
  def self.catalog_inventory
    catalog = Catalog.find_by(name: 'Catalog')
    raise "Catalog not found" unless catalog

    catalog.parts.includes(:part_options).each_with_object({}) do |part, hash|
      hash[part.part_key.to_sym] = part.part_options.select(&:in_stock).map(&:option)
    end
  end

  def self.validate(input)
    errors = {}
    inventory = catalog_inventory

    input.each do |key, value|
      available = inventory[key]
      unless available && available.include?(value)
        errors[key] ||= []
        errors[key] << "selected #{key.to_s.gsub('_', ' ')} '#{value}' is out of stock"
      end
    end

    # Custom wheels validations.
    if input[:wheels] == "mountain wheels" && input[:frame_type] != "full-suspension"
      errors[:wheels] ||= []
      errors[:wheels] << "requires a full-suspension frame when using mountain wheels"
    end

    if input[:wheels] == "fat bike wheels" && input[:rim_color] == "red"
      errors[:wheels] ||= []
      errors[:wheels] << "red rim is not allowed with fat bike wheels"
    end

    errors
  end
end
