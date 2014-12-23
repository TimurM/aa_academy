class Towers
  attr_reader :stacks

  def self.generate_discs
    (1..3).to_a.reverse
  end

  def self.generate_stacks
    [Towers.generate_discs, [], []]
  end

  def initialize(stacks = Towers.generate_stacks)
    @stacks = stacks
  end

  def move(from_pos, to_pos)

    if stacks[to_pos].empty? || @stacks[from_pos].last < @stacks[to_pos].last
      stacks[to_pos] << stacks[from_pos].pop
    end
    stacks
  end

  def won?
    if stacks[0].empty? && (stacks[1].empty? || stacks[2].empty?)
      return true
    else
      return false
    end
  end

  def run_game

    until won?
      x, y = get_moves

      move(x,y)
    end

    "You Won the Game"
  end

  private

  def get_moves
    puts "enter from which pile you would like to move the disk: "
    puts "(0..1..2)"
    from_stack = gets.chomp.to_i

    puts "enter to which pile you would like to move teh disk: "
    to_stack = gets.chomp.to_i

    [from_stack, to_stack]
  end


end
