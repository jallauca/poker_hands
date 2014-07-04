require 'set'

def input_to_hands(input)
  split_hands = input.scan(/\w+:(?:\s(?:[0-9AJKQ]|10)[HDSC]){5}/)
  split_hands.reduce({ }) do |hash, hand|
    name, cards = hand.split(":")
    hash[name] = cards.strip.split(" ")
    hash
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
               full_house_score(cards, ranks) ||
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

def straight_flush_score(cards, ranks)
  score1 = straight_score(cards, ranks)
  score2 = flush_score(cards, ranks)
  [9] + score1[1..-1] if score1 && score2
end

def four_of_kind_score(cards, ranks)
  four_of_kind = Set.new(ranks).find { |c| ranks.count(c) == 4 }
  [8, four_of_kind] if four_of_kind
end

def full_house_score(cards, ranks)
  set = Set.new(ranks)
  three_of_kind = set.find { |c| ranks.count(c) == 3 }
  two_of_kind = set.find { |c| ranks.count(c) == 2 }
  [7, three_of_kind, two_of_kind] if three_of_kind && two_of_kind
end

def flush_score(cards, ranks)
  is_flush = cards.all? { |c| c[-1] == cards.first[-1] }
  [6] if is_flush
end

def straight_score(cards, ranks)
  is_straight = ranks.each_cons(2).all? { |r1, r2| (r1 - r2).abs == 1 }
  [5] if is_straight
end

def three_of_kind_score(cards, ranks)
  three_of_kind = Set.new(ranks).find { |c| ranks.count(c) == 3 }
  [4, three_of_kind] if three_of_kind
end

def two_pair_score(cards, ranks)
  two_pairs = Set.new(ranks).find_all { |c| ranks.count(c) == 2 }
  [3] + two_pairs.sort.reverse if two_pairs.count == 2
end

def pair_score(cards, ranks)
  pair = Set.new(ranks).find_all { |c| ranks.count(c) == 2 }
  [2] + pair if pair.count == 1
end

@indexed_cards =
  "0 1 2 3 4 5 6 7 8 9 10 J Q K A"
  .split(" ")
  .each_with_index
  .reduce({ }) { |hash, (number, i)| hash[number] = i; hash }

def get_ranks(cards)
  cards.map { |c| @indexed_cards[ c[0..-2] ] }.sort.reverse
end

def hand_comparison(hand1, hand2)
  _, score1 = hand1
  _, score2 = hand2

  score1.each_with_index do |_, i|
    cmp = score1[i] <=> score2[i]
    return cmp unless cmp == 0
  end
  return 0
end
