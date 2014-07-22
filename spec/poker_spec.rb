require File.join(File.dirname(__FILE__), '../lib', 'poker')

describe Poker do

  it "parse should identify hands and respective list of cards" do
    expect(
      Poker.send(:parse,
                 "Black: 2H 3D 5S TC KD White: 2C 3H 4S 8C AH")).to eq(
        {
          'Black' => [ '2H', '3D', '5S', 'TC', 'KD' ],
          'White' => [ '2C', '3H', '4S', '8C', 'AH' ]
        }
      )

    expect(
      Poker.send(:parse,
                 "Black: 2H 4S 4C 2D 4H White: 2S 8S AS QS 3S")).to eq(
        {
          'Black' => [ '2H', '4S', '4C', '2D', '4H' ],
          'White' => [ '2S', '8S', 'AS', 'QS', '3S' ]
        }
      )

    expect(
      Poker.send(:parse,
                 "Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C KH Blue: 8C 9H JC QS KC")).to eq(
        {
          'Black' => [ '2H', '3D', '5S', '9C', 'KD' ],
          'White' => [ '2C', '3H', '4S', '8C', 'KH' ],
          'Blue'  => [ '8C', '9H', 'JC', 'QS', 'KC' ]
        }
      )
  end

  it "throws an exception if validation does not pass" do
    hands_winners = [
      ["Black: 2C JC 3H JD 3S JS 2D TH White: QH QD TS JH QD KS AC"],
      ["Black: 2C JC 3H JD 3S JS White: QH QD TD JD QD KD AD"],
    ]
    hands_winners.each do |(h, w)|
      expect { Poker.find_winner(h) }.to raise_exception(ArgumentError, "Invalid hand count")
    end
  end

  it "determines winner between two players" do
    hands_winners = [
      ["Black: 2H 3H 4H 5H 6H White: 3C 3H 4S 8C AH",
       "Black wins - Straight Flush"],
      ["Black: 2H 3H 4H 5H AH White: 3C 3H 4S 8C AH",
       "Black wins - Straight Flush"],
      ["Black: 3C 3H 3S 8C 8H White: 2H 4H 4D 4S 4C",
       "White wins - Four of a Kind"],
      ["Black: 3C 3H 3S 8C 8H White: 2H 4H 6H 8H JH",
       "Black wins - Full House"],
      ["Black: 2H 4H 6H 8H JH White: 2H 3D 4H 5S 6C",
       "Black wins - Flush"],
      ["Black: 3C 3H 3S 2C 8H White: 6H 5D 4H 3S 2C",
       "White wins - Straight"],
      ["Black: 3C 3H 3S 2C 8H White: AH 5D 4H 3S 2C",
       "White wins - Straight"],
      ["Black: 3C 3H 3S 2C 8H Green: 2H 2D 4H 4S 6C",
       "Black wins - Three of a Kind"],
      ["Black: JC 3H QS 2C 8H Green: 2H 2D 4H 4S 6C",
       "Green wins - Two Pairs"],
      ["Black: JC 3H 3S 2C 8H Green: 2H 3D 5S 9C KD",
       "Black wins - Pair"],
      ["Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH",
       "White wins - High Card: A"],
    ]

    hands_winners.each do |(h, w)|
      expect( Poker.find_winner(h) ).to eq( w )
    end
  end

  it "determines a tie" do
    expect( Poker.find_winner("Black: 2H 3D 5S 9C KD White: 2C 3H 5C 9H KC") )
       .to eq( "Black, White - Tie" )
  end

  it "determines high card  between two players when they have the same rank" do
    hands_winners = [
      ["Black: 2H 3H 4H 5H 6H White: 3C 4C 5C 6C 7C",
       "White wins - Straight Flush High Card: 7"],
      ["Black: 2H 3H 4H 5H 6H White: AC 2C 3C 4C 5C",
       "Black wins - Straight Flush High Card: 6"],
      ["Black: 4H 4D 4S 4C 8H White: 2H 4H 4D 4S 4C",
       "Black wins - Four of a Kind High Card: 8"],
      ["Black: 3C 3H 3S 8C 8H White: 3C 3H 3S JH JH",
       "White wins - Full House High Card: J"],
      ["Black: 2H 4H 6H 8H JH White: 2C 4C 7C 8C JC",
       "White wins - Flush High Card: 7"],
      ["Black: AC 2S 3C 4D 5C White: 6H 5D 4H 3S 2C",
       "White wins - Straight High Card: 6"],
      ["Black: 4C 5H 6S 7C 8H White: 6H 5D 4H 3S 2C",
       "Black wins - Straight High Card: 8"],
      ["Black: 3C 3H 3S 2C 8H Green: 3H 3D 3C 4S QC",
       "Green wins - Three of a Kind High Card: Q"],
      ["Black: 2C 2H 4S 4C 8H Green: 2H 2D 4H 4S 6C",
       "Black wins - Two Pairs High Card: 8"],
      ["Black: JC 3H 3S 2C 8H Green: 2H 3D 3S 9C KD",
       "Green wins - Pair High Card: K"],
      ["Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH",
       "White wins - High Card: A"],
    ]

    hands_winners.each do |(h, w)|
      expect( Poker.find_winner(h) ).to eq( w )
    end
  end

  it "determines winner between two players and seven cards" do
    hands_winners = [
      ["Black: 2C JC 3H JD 3S JS 2D White: QH QD TS JH QD KS AC", "Black wins - Full House"],
      ["Black: 2C JC 3H JD 3S JS 2D White: QH QD TD JD QD KD AD", "White wins - Straight Flush"],
    ]

    hands_winners.each do |(h, w)|
      expect( Poker.find_winner(h) ).to eq( w )
    end
  end

  it "determines winner between players in Texas Hold'em" do
    hands_winners = [
      ["House: QH QD JC 3H JD Black: JH QS White: 2S TS", "Black wins - Full House"],
      ["House: QH QD JC 3H JD Black: 3S TS White: KD AD", "White wins - Two Pairs High Card: A"],
      ["House: QH QD JC 3H JD Black: 3S TS White: KD AD Green: QS QD", "Green wins - Four of a Kind"],
    ]

    hands_winners.each do |(h, w)|
      expect( Poker.find_winner(h) ).to eq( w )
    end
  end

  it "get_play_score_tests" do
    expect( Poker.send(:get_score, [ '2H','3H','4H','5H','6H' ]) ).to eq( [9,6,     5,4,3,2] )
    expect( Poker.send(:get_score, [ '2H','4H','4D','4S','4C' ]) ).to eq( [8,4,     4,4,4,4,2] )
    expect( Poker.send(:get_score, [ '3C','3H','3S','8C','8H' ]) ).to eq( [7,3,8,   8,8,3,3,3] )
    expect( Poker.send(:get_score, [ '2H','4H','6H','8H','JH' ]) ).to eq( [6,       11,8,6,4,2] )
    expect( Poker.send(:get_score, [ '2H','3D','4H','5S','6C' ]) ).to eq( [5,       6,5,4,3,2] )
    expect( Poker.send(:get_score, [ '3H','2D','4H','4S','4C' ]) ).to eq( [4,4,     4,4,4,3,2] )
    expect( Poker.send(:get_score, [ '8H','8D','4H','4S','5C' ]) ).to eq( [3,8,4,   8,8,5,4,4] )
    expect( Poker.send(:get_score, [ '8H','8D','QH','4S','5C' ]) ).to eq( [2,8,     12,8,8,5,4] )
    expect( Poker.send(:get_score, [ '2H','3D','5S','9C','KD' ]) ).to eq( [1,       13,9,5,3,2] )
  end

end
