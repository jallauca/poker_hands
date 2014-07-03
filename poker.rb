#!/usr/bin/env ruby

def input_to_hands(input)
  split_hands = input.scan(/\w+:(?:\s[0-9AJKQ][HDSC]){5}/)
  split_hands.reduce({ }) do |h, s|
    name, cards = s.split(":")
    h[ name ] = cards.strip.split(" ")
    h
  end
end

def winner(hands)
  hand_scores = hands.reduce({ }) do |memo, (name, cards)|
    score = get_cards(cards)
    memo[name] = score
    memo
  end

  won = hand_scores.max { |hand1, hand2| hand_comparison(hand1, hand2) }
  won[0]
end

@indexed_cards = 
  "0 1 2 3 4 5 6 7 8 9 10 J Q K A"
  .split(" ")
  .each_with_index
  .reduce({ }) { |h, (n, i)| h[n] = i; h }

def get_cards(cards)
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
    input_to_hands("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C KH") ==
      {
        'Black' => [ '2H', '3D', '5S', '9C', 'KD' ],
        'White' => [ '2C', '3H', '4S', '8C', 'KH' ]
      }
  end
  assert do 
    input_to_hands("Black: 2H 3D 5S 9C KD White: 2D 3H 5C 9S KH") ==
      {
        'Black' => [ '2H', '3D', '5S', '9C', 'KD' ],
        'White' => [ '2D', '3H', '5C', '9S', 'KH' ]
      }
  end
  puts 'tests pass'
end

def winner_tests
  assert do 
    w = winner(input_to_hands("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH"))
    w == "White"
  end
end

class AssertionError < RuntimeError
end

def assert &block
  raise AssertionError unless yield
end

script_main
