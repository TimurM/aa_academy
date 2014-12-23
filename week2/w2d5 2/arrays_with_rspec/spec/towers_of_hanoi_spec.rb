require 'rspec'
require 'towers_of_hanoi.rb'

describe Towers do

  it "creates three arrays representing piles of disks" do
    expect(Towers.generate_discs.count).to eq(3)
  end

  it "create an array where three disks in the first stack" do
    expect(Towers.generate_stacks.count).to eq(3)
  end

  describe 'a towers instance' do
    subject(:game) { Towers.new }

    it "initialize stacks for the the game when class loads" do
      expect(game.stacks).to eq([[3, 2, 1], [], []])
    end

    it "should not win the game" do
      expect(game.won?).to eq(false)
    end

    it "should move disks from one column to user's choice " do
      expect(game.move(0, 1)).to eq([[3, 2], [1], []])
    end

    it "should return true if the user won the game" do
      game.move(0,1)
      game.move(0,2)
      game.move(1,2)
      game.move(0,1)
      game.move(2,0)
      game.move(2,1)
      game.move(0,1)

      expect(game.won?).to eq(true)
    end
  end

end

#Functionality:

#Create three array which contain the piles of disks


#Create a loop that will ask the user for input
#Get the user to tell you the move from where and to where they want to move the disks
#check to see if the from place contains disks
#check to see if the to place is empty or is greater than the 'new disk'
#Check to see if the user won

#UI

#Display the board
#Make sure the arrays contain display correct number of discs
