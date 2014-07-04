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
              three_of_kind_rank(cards, score) ||
              two_pair_rank(cards, score) ||
              pair_rank(cards, score) ||
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
    when 4 ; "Three of a Kind"
    when 3 ; "Two Pairs"
    when 2 ; "Pair"
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

def three_of_kind_rank(cards, score)
  three_of_kind = Set.new(score).find { |c| score.count(c) == 3 }
  [4, three_of_kind] if three_of_kind
end

def two_pair_rank(cards, score)
  two_pairs = Set.new(score).find_all { |c| score.count(c) == 2 }
  [3] + two_pairs.sort.reverse if two_pairs.count == 2
end

def pair_rank(cards, score)
  pair = Set.new(score).find_all { |c| score.count(c) == 2 }
  [2] + pair if pair.count == 1
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
