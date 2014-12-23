require 'rspec'
require 'hand'

describe Hand do
  let(:cards) {[
                Card.new(:spades, :ten),
                Card.new(:hearts, :five),
                Card.new(:hearts, :ace),
                Card.new(:diamonds, :two),
                Card.new(:hearts, :two)
                ]}

  subject(:hand) { Hand.new(cards) }

  describe '#initialize' do
    it 'accepts cards correctly' do
      expect(hand.cards).to match_array(cards)
    end

    it 'raises an error if not five cards' do
      expect do
        Hand.new(cards[0..3])
      end.to raise_error 'must have five cards'
    end
  end

  describe '#trade_cards' do
    let!(:take_cards) { hand.cards[0..1] }
    let!(:new_cards) { [Card.new(:spades, :five), Card.new(:clubs, :three)] }

    it 'discards specifified cards' do
      hand.trade_cards(take_cards, new_cards)
      expect(hand.cards).to_not include(*take_cards)
    end

    it 'takes specified cards' do
      hand.trade_cards(take_cards, new_cards)
      expect(hand.cards).to include(*new_cards)
    end

    it 'raises an error if trade does not result in five cards' do
      expect do
        hand.trade_cards(hand.cards[0..0], new_cards)
      end.to raise_error 'must have five cards'
    end

    it 'raises an error if trade tries to discard unowned card' do
      expect do
        hand.trade_cards([Card.new(:hearts, :ten)], new_cards[0..0])
      end.to raise_error 'cannot discard unowned card'
    end
  end

      describe 'poker hands' do
      let(:royal_flush) do
      Hand.new([
      Card.new(:spades, :ace),
      Card.new(:spades, :king),
      Card.new(:spades, :queen),
      Card.new(:spades, :jack),
      Card.new(:spades, :ten)
      ])
      end

      let(:straight_flush) do
      Hand.new([
      Card.new(:spades, :eight),
      Card.new(:spades, :seven),
      Card.new(:spades, :six),
      Card.new(:spades, :five),
      Card.new(:spades, :four)
      ])
      end

      let(:four_of_a_kind) do
      Hand.new([
      Card.new(:spades, :ace),
      Card.new(:hearts, :ace),
      Card.new(:diamonds, :ace),
      Card.new(:clubs, :ace),
      Card.new(:spades, :ten)
      ])
      end

      let(:full_house) do
      Hand.new([
      Card.new(:spades, :ace),
      Card.new(:clubs, :ace),
      Card.new(:spades, :king),
      Card.new(:hearts, :king),
      Card.new(:diamonds, :king)
      ])
      end

      let(:flush) do
      Hand.new([
      Card.new(:spades, :four),
      Card.new(:spades, :seven),
      Card.new(:spades, :ace),
      Card.new(:spades, :two),
      Card.new(:spades, :eight)
      ])
      end

      let(:straight) do
      Hand.new([
      Card.new(:hearts, :king),
      Card.new(:hearts, :queen),
      Card.new(:diamonds, :jack),
      Card.new(:clubs, :ten),
      Card.new(:spades, :nine)
      ])
      end

      let(:three_of_a_kind) do
      Hand.new([
      Card.new(:spades, :three),
      Card.new(:diamonds, :three),
      Card.new(:hearts, :three),
      Card.new(:spades, :jack),
      Card.new(:spades, :ten)
      ])
      end

      let(:two_pair) do
      Hand.new([
      Card.new(:hearts, :king),
      Card.new(:diamonds, :king),
      Card.new(:spades, :queen),
      Card.new(:clubs, :queen),
      Card.new(:spades, :ten)
      ])
      end

      let(:one_pair) do
      Hand.new([
      Card.new(:spades, :ace),
      Card.new(:spades, :ace),
      Card.new(:hearts, :queen),
      Card.new(:diamonds, :jack),
      Card.new(:hearts, :ten)
      ])
      end

      let(:high_card) do
      Hand.new([
      Card.new(:spades, :two),
      Card.new(:hearts, :four),
      Card.new(:diamonds, :six),
      Card.new(:spades, :nine),
      Card.new(:spades, :ten)
      ])
      end

      let(:hand_ranks) do
      [
      :royal_flush,
      :straight_flush,
      :four_of_a_kind,
      :full_house,
      :flush,
      :straight,
      :three_of_a_kind,
      :two_pair,
      :one_pair,
      :high_card
      ]
      end

      let!(:hands) do
      [
      royal_flush,
      straight_flush,
      four_of_a_kind,
      full_house,
      flush,
      straight,
      three_of_a_kind,
      two_pair,
      one_pair,
      high_card
      ]
      end

          describe 'rank' do
          it 'should correctly identify the hand rank' do
          hands.each_with_index do |hand, i|
          expect(hand.rank).to eq(hand_ranks[i])
          end
          end

          context 'when straight' do
          let(:ace_straight) do
          Hand.new([
          Card.new(:hearts, :ace),
          Card.new(:spades, :two),
          Card.new(:hearts, :three),
          Card.new(:hearts, :four),
          Card.new(:hearts, :five)
          ])
          end

          it 'should allow ace as the low card' do
          expect(ace_straight.rank).to eq(:straight)
          end
        end
      end
    end


end
