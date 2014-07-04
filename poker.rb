require 'set'

def input_to_hands(input)
  split_hands = input.scan(/\w+:(?:\s(?:[0-9AJKQ]|10)[HDSC]){5}/)
  split_hands.reduce({ }) do |h, s|
    name, cards = s.split(":")
    h[ name ] = cards.strip.split(" ")
    h
  end
end

def winner(hands)
  hand_scores = get_scores(hands)
  winner, score = hand_scores.max { |hand1, hand2| hand_comparison(hand1, hand2) }
  "#{winner} - #{get_play_label(score)}"
end

def get_scores(hands)
  hands.reduce({ }) do |memo, (name, cards)|
    memo[name] = get_play_score(cards)
    memo
  end
end

def get_play_score(cards)
  ranks = get_ranks(cards)

  play_score = straight_flush_score(cards, ranks) ||
               four_of_kind_score(cards, ranks) ||
               full_house(cards, ranks) ||
               flush_score(cards, ranks) ||
               straight_score(cards, ranks) ||
               three_of_kind_score(cards, ranks) ||
               two_pair_score(cards, ranks) ||
               pair_score(cards, ranks) ||
               [1]

  return play_score + ranks
end

def get_play_label(score)
  case score[0]
    when 9 ; "Straight Flush"
    when 8 ; "Four of a Kind"
    when 7 ; "Full House"
    when 6 ; "Flush"
    when 5 ; "Straight"
    when 4 ; "Three of a Kind"
    when 3 ; "Two Pairs"
    when 2 ; "Pair"
    else ; "High Card"
  end
end

def straight_flush_score(cards, score)
  rank1 = straight_score(cards, score)
  rank2 = flush_score(cards, score)
  [9] + rank1[1..-1] if rank1 && rank2
end

def four_of_kind_score(cards, score)
  four_of_kind = Set.new(score).find { |c| score.count(c) == 4 }
  [8, four_of_kind] if four_of_kind
end

def full_house(cards, score)
  set = Set.new(score)
  three_of_kind = set.find { |c| score.count(c) == 3 }
  two_of_kind = set.find { |c| score.count(c) == 2 }
  [7, three_of_kind, two_of_kind] if three_of_kind && two_of_kind
end

def flush_score(cards, score)
  is_flush = cards.all? { |c| c[-1] == cards.first[-1] }
  [6] if is_flush if is_flush
end

def straight_score(cards, score)
  is_straight = ( 0...score.count-1 ).all? { |i| score[i] - score[i+1] == 1 }
  [5] if is_straight
end

def three_of_kind_score(cards, score)
  three_of_kind = Set.new(score).find { |c| score.count(c) == 3 }
  [4, three_of_kind] if three_of_kind
end

def two_pair_score(cards, score)
  two_pairs = Set.new(score).find_all { |c| score.count(c) == 2 }
  [3] + two_pairs.sort.reverse if two_pairs.count == 2
end

def pair_score(cards, score)
  pair = Set.new(score).find_all { |c| score.count(c) == 2 }
  [2] + pair if pair.count == 1
end

@indexed_cards =
  "0 1 2 3 4 5 6 7 8 9 10 J Q K A"
  .split(" ")
  .each_with_index
  .reduce({ }) { |h, (n, i)| h[n] = i; h }

def get_ranks(cards)
  cards.map { |c| @indexed_cards[ c[0..-2] ] }.sort.reverse
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
