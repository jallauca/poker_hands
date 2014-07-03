#!/usr/bin/env ruby

require 'set'

def input_to_hands(input)
  split_hands = input.scan(/\w+:(?:\s[0-9AJKQ][HDSC]){5}/)
  split_hands.reduce({ }) do |h, s|
    name, cards = s.split(":")
    h[ name ] = cards.strip.split(" ")
    h
  end
end

def winner(hands)
  hand_scores = get_scores(hands)
  won = hand_scores.max { |hand1, hand2| hand_comparison(hand1, hand2) }
  "#{won[0]} - #{get_play_label(won[1])}"
end

def get_scores(hands)
  hands.reduce({ }) do |memo, (name, cards)|
    memo[name] = get_play_rank(cards)
    memo
  end
end

def get_play_rank(cards)
  score = get_ranks(cards)

  play_rank = straight_flush_rank(cards, score) ||
              four_of_kind_rank(cards, score) ||
              full_house(cards, score) ||
              flush_rank(cards, score) ||
              straight_rank(cards, score) ||
              [1]
  return play_rank + score
end

def get_play_label(score)
  case score[0]
    when 9 ; "Straight Flush"
    when 8 ; "Four of a Kind"
    when 7 ; "Full House"
    when 6 ; "Flush"
    when 5 ; "Straight"
    else ; "High Card"
  end
end

def straight_flush_rank(cards, score)
  rank1 = straight_rank(cards, score)
  rank2 = flush_rank(cards, score)
  [9] + rank1[1..-1] if rank1 && rank2
end

def four_of_kind_rank(cards, score)
  four_of_kind = Set.new(score).find { |c| score.count(c) == 4 }
  [8, four_of_kind] if four_of_kind
end

def full_house(cards, score)
  set = Set.new(score)
  three_of_kind = set.find { |c| score.count(c) == 3 }
  two_of_kind = set.find { |c| score.count(c) == 2 }
  [7, three_of_kind, two_of_kind] if three_of_kind && two_of_kind
end

def flush_rank(cards, score)
  is_flush = cards.all? { |c| c[-1] == cards.first[-1] }
  [6] if is_flush if is_flush
end

def straight_rank(cards, score)
  is_straight = ( 0...score.count-1 ).all? { |i| score[i] - score[i+1] == 1 }
  [5] if is_straight
end

@indexed_cards = 
  "0 1 2 3 4 5 6 7 8 9 10 J Q K A"
  .split(" ")
  .each_with_index
  .reduce({ }) { |h, (n, i)| h[n] = i; h }

def get_ranks(cards)
  cards.map { |c| @indexed_cards[ c[0] ] }.sort.reverse
end

def hand_comparison(hand1, hand2)
  _, score1 = hand1
  _, score2 = hand2
  
  cmp = 0
  score1.each_with_index do |c, i|
    cmp = score1[i] <=> score2[i]
    break unless cmp == 0
  end

  cmp
end

def script_main
  tests_flag = false
  input = ""

  ARGV.each do |value|
    tests_flag = true if value == '--tests'
  end

  return show_tests if tests_flag
  return show_help unless ARGV.count == 1

  w = winner( input_to_hands(ARGV[0]) )
  puts "#{w} wins"
end

def show_help
  puts "poker \"input\""
  puts "poker --tests\t\trun tests"
end

def show_tests
  input_to_hands_tests
  winner_tests
  get_play_rank_tests

  puts 'tests pass'
end

def input_to_hands_tests
  assert do 
    input_to_hands("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH") ==
      {
        'Black' => [ '2H', '3D', '5S', '9C', 'KD' ],
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
  assert do 
    w = winner(input_to_hands("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH"))
    w == "White - High Card"
  end
  assert do
    w = winner(input_to_hands("Black: 2H 3H 4H 5H 6H White: 2C 3H 4S 8C AH"))
    w == "Black - Straight Flush"
  end
  assert do
    w = winner(input_to_hands("Black: 3C 3H 3S 8C 8H White: 2H 4H 4D 4S 4C"))
    w == "White - Four of a Kind"
  end
  assert do
    w = winner(input_to_hands("Black: 3C 3H 3S 8C 8H White: 2H 4H 6H 8H JH"))
    w == "Black - Full House"
  end
  assert do
    w = winner(input_to_hands("Black: 2H 4H 6H 8H JH White: 2H 3D 4H 5S 6C"))
    w == "Black - Flush"
  end
  assert do
    w = winner(input_to_hands("Black: 3C 3H 2S 2C 8H White: 2H 3D 4H 5S 6C"))
    w == "White - Straight"
  end
end

def get_play_rank_tests
  assert { get_play_rank([ '2H','3H','4H','5H','6H' ]) == [9,6,5,4,3,2] }
  assert { get_play_rank([ '2H','4H','4D','4S','4C' ]) == [8,4,4,4,4,4,2] }
  assert { get_play_rank([ '3C','3H','3S','8C','8H' ]) == [7,3,8,8,8,3,3,3] }
  assert { get_play_rank([ '2H','4H','6H','8H','JH' ]) == [6,11,8,6,4,2] }
  assert { get_play_rank([ '2H','3D','4H','5S','6C' ]) == [5,6,5,4,3,2] }
end

class AssertionError < RuntimeError
end

def assert &block
  raise AssertionError unless yield
end

script_main
