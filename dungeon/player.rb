class Player
  attr_accessor :name, :location, :items

  def initialize(player_name)
    @name = player_name
    @items = []
  end
end