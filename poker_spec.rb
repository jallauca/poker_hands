require File.join(File.dirname(__FILE__), '../lib', 'poker')

describe Poker do

  it "input_to_hands should identify hands and respective list of cards" do
    # poker = class PokerTest ; include Poker ; end
    expect(
      Poker.send(:input_to_hands,
                 "Black: 2H 3D 5S 10C KD White: 2C 3H 4S 8C AH")).to eq(
        {
          'Black' => [ '2H', '3D', '5S', '10C', 'KD' ],
          'White' => [ '2C', '3H', '4S', '8C', 'AH' ]
        }
      )

    expect(
      Poker.send(:input_to_hands,
                 "Black: 2H 4S 4C 2D 4H White: 2S 8S AS QS 3S")).to eq(
        {
          'Black' => [ '2H', '4S', '4C', '2D', '4H' ],
          'White' => [ '2S', '8S', 'AS', 'QS', '3S' ]
        }
      )

    expect(
      Poker.send(:input_to_hands,
                 "Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C KH Blue: 8C 9H JC QS KC")).to eq(
        {
          'Black' => [ '2H', '3D', '5S', '9C', 'KD' ],
          'White' => [ '2C', '3H', '4S', '8C', 'KH' ],
          'Blue'  => [ '8C', '9H', 'JC', 'QS', 'KC' ]
        }
      )
  end

  it "determines winner between two players" do
    hands_winners = [
      ["Black: 2H 3H 4H 5H 6H White: 3C 3H 4S 8C AH", "Black - Straight Flush"],
      ["Black: 3C 3H 3S 8C 8H White: 2H 4H 4D 4S 4C", "White - Four of a Kind"],
      ["Black: 3C 3H 3S 8C 8H White: 2H 4H 6H 8H JH", "Black - Full House"],
      ["Black: 2H 4H 6H 8H JH White: 2H 3D 4H 5S 6C", "Black - Flush"],
      ["Black: 3C 3H 3S 2C 8H White: 6H 5D 4H 3S 2C", "White - Straight"],
      ["Black: 3C 3H 3S 2C 8H Green: 2H 2D 4H 4S 6C", "Black - Three of a Kind"],
      ["Black: JC 3H QS 2C 8H Green: 2H 2D 4H 4S 6C", "Green - Two Pairs"],
      ["Black: JC 3H 3S 2C 8H Green: 2H 3D 5S 9C KD", "Black - Pair"],
      ["Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH", "White - High Card"],
      ["Black: 2H 3D 5S 9C KD White: 2C 3H 5C 9H KC", "Black, White - Tie"],
    ]

    hands_winners.each do |(h, w)|
      expect( Poker.find_winner(h) ).to eq( w )
    end
  end

  it "determines winner between two players and seven cards" do
    hands_winners = [
      ["Black: 2C JC 3H JD 3S JS 2D White: QH QD 10S JH QD KS AC", "Black - Full House"],
      ["Black: 2C JC 3H JD 3S JS 2D White: QH QD 10D JD QD KD AD", "White - Straight Flush"],
    ]

    hands_winners.each do |(h, w)|
      expect( Poker.find_winner(h) ).to eq( w )
    end
  end

  it "get_play_score_tests" do
    expect( Poker.send(:get_play_score, [ '2H','3H','4H','5H','6H' ]) ).to eq( [9,6,     5,4,3,2] )
    expect( Poker.send(:get_play_score, [ '2H','4H','4D','4S','4C' ]) ).to eq( [8,4,     4,4,4,4,2] )
    expect( Poker.send(:get_play_score, [ '3C','3H','3S','8C','8H' ]) ).to eq( [7,3,8,   8,8,3,3,3] )
    expect( Poker.send(:get_play_score, [ '2H','4H','6H','8H','JH' ]) ).to eq( [6,       11,8,6,4,2] )
    expect( Poker.send(:get_play_score, [ '2H','3D','4H','5S','6C' ]) ).to eq( [5,       6,5,4,3,2] )
    expect( Poker.send(:get_play_score, [ '3H','2D','4H','4S','4C' ]) ).to eq( [4,4,     4,4,4,3,2] )
    expect( Poker.send(:get_play_score, [ '8H','8D','4H','4S','5C' ]) ).to eq( [3,8,4,   8,8,5,4,4] )
    expect( Poker.send(:get_play_score, [ '8H','8D','QH','4S','5C' ]) ).to eq( [2,8,     12,8,8,5,4] )
    expect( Poker.send(:get_play_score, [ '2H','3D','5S','9C','KD' ]) ).to eq( [1,       13,9,5,3,2] )
  end

end
