class Room
  attr_accessor :reference, :name, :description, :connections, :item

  def initialize(reference, name, description, item_name = nil, connections)
    @reference = reference
    @name = name
    @description = description
    @item = item_name.nil? ? nil : Item.new(item_name)
    @connections = connections
  end

  def full_description
    location_description + item_in_location + "\n\nDirections you can go: \n" + directions
  end

  def location_description
    "################\n" + @name + "\n\nYou are in " + @description
  end

  def item_in_location
    @item.nil? ? '' : "\n\nFOUND ITEM: " + @item.name
  end

  def directions
    @connections.map { |key, value| "#{key.to_s.capitalize} -> #{value.to_s.capitalize}\n" }.flatten.join
  end

  def pick
    current_item = item.dup
    @item = nil
    current_item
  end
end