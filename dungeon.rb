require 'pry'
class Dungeon
  attr_accessor :player, :hash_of_moves

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
    @hash_of_moves = {}
  end

  def start(location)
    @player.location = location
    show_current_description
  end

  def show_current_description
    puts find_room_in_dungeon(player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def go(direction)
    puts "\nYou go " + direction.to_s + " -->>\n\n"
    @player.location = find_room_in_direction(direction)
  end

  def pick_item
    player.items << item = find_room_in_dungeon(player.location).pick
    puts "\n|_| Picked: #{item.name} "
  end

  def inventory
    puts "\n***Your equipment***"
    items_count = 1
    player.items.each do |item|
      puts "\n#{items_count}. #{item.name}"
      items_count += 1
    end
    puts '*******'
  end

  def things_you_can_do
    counter = 0
    puts "\nMake your move:"
    ways_to_go = find_room_in_dungeon(player.location).connections.map { |key, value| counter +=1; hash_of_moves[counter] = ":#{key}";"[#{counter}] Go #{key.to_s} -> #{value.to_s.capitalize}\n" }.flatten.join
    puts ways_to_go
    unless find_room_in_dungeon(player.location).item.nil?
      counter += 1
      hash_of_moves[counter] = 'pick_item'
      puts "[#{counter}] Pick item"
    end
    counter += 1
    hash_of_moves[counter] = 'inventory'
    puts "[#{counter}] View your inventory"
    counter += 1
    hash_of_moves[counter] = 'say_something_deep'
    puts "[#{counter}] Say something Deep"
  end

  def say_something_deep
    deep_list = [
      'This game is fun like my last girlfriend',
      'When you die, you will be death',
      'It takes time to grow old.',
      'It is better to pee sitting down than standing up standing.',
      'The most important things in life are not things.'
    ]
    puts deep_list.sample
  end

  def player_input(input)
    system('clear')
    return unless hash_of_moves.keys.to_s.include?(input)
    if hash_of_moves[input.to_i] =~ /:/
      send('go',hash_of_moves[input.to_i].sub(':', '').to_sym)
    else
      send(hash_of_moves[input.to_i])
    end
  end

  class Player
    attr_accessor :name, :location, :items

    def initialize(player_name)
      @name = player_name
      @items = []
    end
  end

  class Item
    attr_accessor :name
    def initialize(name)
      @name = name
    end
  end

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
      @connections.map { |key, value| "#{key.to_s}: #{value.to_s}\n" }.flatten.join
    end

    def pick
      current_item = item.dup
      @item = nil
      current_item
    end
  end

  def add_room(reference, name, description, item_name, connections)
    @rooms << Room.new(reference, name, description, item_name, connections)
  end
end

my_dungeon = Dungeon.new('zelears')
my_dungeon.add_room(:largecave, 'Large Cave', 'a large cavernous cave', 'Old strange doll', west: :smallcave, east: :bigcave)
my_dungeon.add_room(:bigcave,'Big Cave', 'big as fuck cave', 'Big Cave achievement', west: :largecave)
my_dungeon.add_room(:smallcave,'Small Cave', 'a small claustrophobic cave', 'Katana', east: :largecave)
my_dungeon.start(:smallcave)
a = 1
system('clear')
while a == 1
  my_dungeon.show_current_description
  my_dungeon.things_you_can_do
  puts 'Make your move:'
  my_dungeon.player_input(gets.chomp)
  my_dungeon.hash_of_moves = {}
end