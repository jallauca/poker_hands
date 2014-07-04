require File.join(File.dirname(__FILE__), '..', 'poker')

def run_tests
  input_to_hands_tests
  winner_tests
  get_play_rank_tests

  puts 'tests pass'
end

def input_to_hands_tests
  assert do
    input_to_hands("Black: 2H 3D 5S 10C KD White: 2C 3H 4S 8C AH") ==
      {
        'Black' => [ '2H', '3D', '5S', '10C', 'KD' ],
        'White' => [ '2C', '3H', '4S', '8C', 'AH' ]
      }
  end
  assert do
    input_to_hands("Black: 2H 4S 4C 2D 4H White: 2S 8S AS QS 3S") ==
      {
        'Black' => [ '2H', '4S', '4C', '2D', '4H' ],
        'White' => [ '2S', '8S', 'AS', 'QS', '3S' ]
      }
  end
  assert do
    input_to_hands("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C KH Blue: 8C 9H JC QS KC") ==
      {
        'Black' => [ '2H', '3D', '5S', '9C', 'KD' ],
        'White' => [ '2C', '3H', '4S', '8C', 'KH' ],
        'Blue'  => [ '8C', '9H', 'JC', 'QS', 'KC' ]
      }
  end
end

def winner_tests
  hands_winners = [
    ["Black: 2H 3H 4H 5H 6H White: 2C 3H 4S 8C AH", "Black - Straight Flush"],
    ["Black: 3C 3H 3S 8C 8H White: 2H 4H 4D 4S 4C", "White - Four of a Kind"],
    ["Black: 3C 3H 3S 8C 8H White: 2H 4H 6H 8H JH", "Black - Full House"],
    ["Black: 2H 4H 6H 8H JH White: 2H 3D 4H 5S 6C", "Black - Flush"],
    ["Black: 3C 3H 3S 2C 8H White: 2H 3D 4H 5S 6C", "White - Straight"],
    ["Black: 3C 3H 3S 2C 8H Green: 2H 2D 4H 4S 6C", "Black - Three of a Kind"],
    ["Black: JC 3H QS 2C 8H Green: 2H 2D 4H 4S 6C", "Green - Two Pairs"],
    ["Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH", "White - High Card"],
  ]

  hands_winners.each do |(h, w)|
    assert { winner(input_to_hands(h)) == w }
  end
end

def get_play_rank_tests
  assert { get_play_rank([ '2H','3H','4H','5H','6H' ]) == [9,6,     5,4,3,2] }
  assert { get_play_rank([ '2H','4H','4D','4S','4C' ]) == [8,4,     4,4,4,4,2] }
  assert { get_play_rank([ '3C','3H','3S','8C','8H' ]) == [7,3,8,   8,8,3,3,3] }
  assert { get_play_rank([ '2H','4H','6H','8H','JH' ]) == [6,       11,8,6,4,2] }
  assert { get_play_rank([ '2H','3D','4H','5S','6C' ]) == [5,       6,5,4,3,2] }
  assert { get_play_rank([ '3H','2D','4H','4S','4C' ]) == [4,4,     4,4,4,3,2] }
  assert { get_play_rank([ '8H','8D','4H','4S','5C' ]) == [3,8,4,   8,8,5,4,4] }
  assert { get_play_rank([ '8H','8D','QH','4S','5C' ]) == [2,8,     12,8,8,5,4] }
  assert { get_play_rank([ '2H','3D','5S','9C','KD' ]) == [1,       13,9,5,3,2] }
end

class AssertionError < RuntimeError
end

def assert &block
  raise AssertionError unless yield
end

run_tests
