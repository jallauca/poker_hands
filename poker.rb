#!/usr/bin/env ruby

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
  puts 'tests pass'
end

def input_to_hands(input)
  split_hands = input.scan(/\w+:(?:\s[0-9AJKQ][HDSC]){5}/)
  split_hash = split_hands.reduce({ }) do |h, s|
    name, cards = s.split(":")
    h[ name ] = cards.strip.split(" ")
    h
  end
  split_hash
end

class AssertionError < RuntimeError
end

def assert &block
  raise AssertionError unless yield
end

script_main
