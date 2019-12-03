require 'pry'
require_relative 'room'
require_relative 'player'
require_relative 'item'
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
      'The most important things in life are not things.'
    ]
    puts deep_list.sample
  end

  def player_input(input)
    system('clear')
    return if input.empty?
    return unless hash_of_moves.keys.to_s.include?(input)
    if hash_of_moves[input.to_i] =~ /:/
      send('go',hash_of_moves[input.to_i].sub(':', '').to_sym)
    else
      send(hash_of_moves[input.to_i])
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