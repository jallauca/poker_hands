#!/usr/bin/env ruby

def input_to_hands(input)
  split_hands = input.scan(/\w+:(?:\s[0-9AJKQ][HDSC]){5}/)
  split_hash = split_hands.reduce({ }) do |h, s|
    name, cards = s.split(":")
    h[ name ] = cards.strip.split(" ")
    h
  end
  split_hash
end

def script_main
  tests_flag = false
  ARGV.each do |value|
    tests_flag = true if value == '--tests'
  end
  show_tests if tests_flag
end

def show_tests
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

class AssertionError < RuntimeError
end

def assert &block
  raise AssertionError unless yield
end

script_main
