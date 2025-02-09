# --- STEP 1: Seed the Catalog (Parts & PartOptions) ---

catalog_data = {
  frame_type:   ["full-suspension", "diamond", "step-through"],
  frame_finish: ["matte", "shiny"],
  wheels:       ["mountain wheels", "road wheels", "fat bike wheels"],
  rim_color:    ["black", "red", "blue"],
  chain:        ["8-speed chain", "single-speed chain"]
}

catalog = Catalog.instance!
catalog_data.each do |part_key, options|
  part = catalog.parts.find_or_create_by!(part_key: part_key.to_s)
  options.each do |opt|
    part.part_options.find_or_create_by!(option: opt) do |part_option|
      part_option.in_stock = true
    end
  end
end

puts "Catalog seeded with parts and part options."

# --- STEP 2: Seed the Concrete Bikes ---

bikes_data = [
  { frame_type: "full-suspension", frame_finish: "matte", wheels: "mountain wheels", rim_color: "black", chain: "8-speed chain" },
  { frame_type: "diamond",         frame_finish: "shiny", wheels: "road wheels",     rim_color: "red",   chain: "single-speed chain" },
  { frame_type: "step-through",    frame_finish: "matte", wheels: "road wheels",     rim_color: "blue",  chain: "8-speed chain" },
  { frame_type: "full-suspension", frame_finish: "shiny", wheels: "mountain wheels", rim_color: "blue",  chain: "8-speed chain" },
  { frame_type: "diamond",         frame_finish: "matte", wheels: "fat bike wheels", rim_color: "black", chain: "single-speed chain" }
]

Bicycle.destroy_all
bikes_data.each_with_index do |data, index|
  begin
    builder = BicycleBuilder.new
                .set_frame_type(data[:frame_type])
                .set_frame_finish(data[:frame_finish])
                .set_wheels(data[:wheels])
                .set_rim_color(data[:rim_color])
                .set_chain(data[:chain])
    bike = builder.build
    config = bike.custom_product_parts.includes(:part, :part_option)
                 .map { |bp| [bp.part.part_key, bp.part_option.option] }
                 .to_h
    puts "Created Bicycle ##{bike.id} with configuration: #{config}"
  rescue StandardError => e
    puts "Error creating bike #{index+1}: #{e.message}"
  end
end
