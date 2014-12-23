require_relative 'deck'
require_relative 'card'

class Hand

  # This is called a *factory method*; it's a *class method* that
  # takes the a `Deck` and creates and returns a `Hand`
  # object. This is in contrast to the `#initialize` method that
  # expects an `Array` of cards to hold.
  def self.deal_from(deck)
    Hand.new(deck.take(2))
  end

  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def points
    aces, sum = 0, 0

    @cards.each do |card|

      begin
        sum += card.blackjack_value
      rescue
        aces += 1
        sum += 11
      end
    end

    aces.times do |ace|
      sum -= 10 if sum > 21
    end

    sum
  end

  def busted?
    self.points > 21
  end

  def hit(deck)
    raise "already busted" if busted?
    @cards.concat(deck.take(1))
  end

  def beats?(other_hand)
    return false if busted?

    other_hand.busted? || self.points > other_hand.points

  end

  def return_cards(deck)
    deck.return(@cards)
    @cards = []
  end

  def to_s
    @cards.join(",") + " (#{points})"
  end
end
