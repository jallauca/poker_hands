require 'set'

module Poker
  class << self

  def find_winner(input)
    winner( input_to_hands(input) )
  end

  private

  def input_to_hands(input)
    split_hands = input.scan(/\w+:(?:\s(?:[0-9AJKQ]|10)[HDSC])*/)
    split_hands.reduce({ }) do |hash, hand|
      name, cards = hand.split(":")
      hash[name] = cards.strip.split(" ")
      hash
    end
  end

  def winner(hands)
    hands = best_hand_combination(hands)
    hand_scores = get_scores(hands)
    desc_hand_comparison = ->(h1, h2) { -hand_comparison(h1, h2) }
    hands_by_score_desc = hand_scores.sort( & desc_hand_comparison )
    first_hand, first_score = hands_by_score_desc.first

    winners = hands_by_score_desc.take_while { |hand, score| score == first_score }

    return display_multiple(winners) if winners.count > 1

    display_winner(hands_by_score_desc)
  end

  def best_hand_combination(hands)
    hands.reduce({ }) do |hash, (hand, cards)|
      _, _, best_cards = cards
                        .combination(5)
                        .map { |c| [hand, get_play_score(c), c] }
                        .max { |h1, h2| hand_comparison(h1, h2) }
      hash[hand] = best_cards
      hash
    end
  end

  def find_high_card(first_score, second_score)
    return nil if first_score[0] > second_score[0]
    high_card, _ = first_score.each_with_index.find do |c, i|
      c > second_score[i] && i > 0
    end
    high_card
  end

  def display_multiple(winners)
    winners_string =  winners.map { |w| w[0] }.join(', ')
    return "#{winners_string} - Tie"
  end

  def display_winner(hands_by_score_desc)
    first_hand, first_score = hands_by_score_desc.first
    second_score = hands_by_score_desc[1][1]
    high_card = find_high_card(first_score, second_score)
    play_label = get_play_label(first_score)

    solution = "#{first_hand} wins -"
    solution += " #{play_label}" if play_label.length > 0
    solution += " High Card: #{indexed_cards_inverse[high_card]}" if high_card
    solution
  end

  def get_scores(hands)
    hands.reduce({ }) do |memo, (name, cards)|
      memo[name] = get_play_score(cards)
      memo
    end
  end

  def get_play_score(cards)
    ranks = get_ranks(cards)
    set = Set.new(ranks)

    play_score = straight_flush_score(cards, ranks, set) ||
                 four_of_kind_score(cards, ranks, set) ||
                 full_house_score(cards, ranks, set) ||
                 flush_score(cards, ranks, set) ||
                 straight_score(cards, ranks, set) ||
                 three_of_kind_score(cards, ranks, set) ||
                 two_pair_score(cards, ranks, set) ||
                 pair_score(cards, ranks, set) ||
                 [1]

    return play_score + ranks
  end

  def indexed_cards
    @indexed_cards =
      "0 1 2 3 4 5 6 7 8 9 10 J Q K A"
      .split(" ")
      .each_with_index
      .reduce({ }) { |hash, (number, i)| hash[number] = i; hash }
  end

  def indexed_cards_inverse
    indexed_cards.reduce({ }) { |hash, (k, v)| hash[v] = k; hash }
  end

  def get_ranks(cards)
    cards = cards.map { |c| indexed_cards[ c[0..-2] ] }.sort.reverse
    return [5,4,3,2,1] if cards == [14,5,4,3,2]
    cards
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
      else   ; ""
    end
  end

  def straight_flush_score(cards, ranks, set)
    score1 = straight_score(cards, ranks, set)
    score2 = flush_score(cards, ranks, set)
    [9] if score1 && score2
  end

  def four_of_kind_score(cards, ranks, set)
    four_of_kind = set.find { |c| ranks.count(c) == 4 }
    [8, four_of_kind] if four_of_kind
  end

  def full_house_score(cards, ranks, set)
    three_of_kind = set.find { |c| ranks.count(c) == 3 }
    two_of_kind = set.find { |c| ranks.count(c) == 2 }
    [7, three_of_kind, two_of_kind] if three_of_kind && two_of_kind
  end

  def flush_score(cards, ranks, set)
    is_flush = cards.all? { |c| c[-1] == cards.first[-1] }
    [6] if is_flush
  end

  def straight_score(cards, ranks, set)
    is_straight = set.count == 5 && (ranks[0] - ranks[-1]) == 4
    [5] if is_straight
  end

  def three_of_kind_score(cards, ranks, set)
    three_of_kind = set.find { |c| ranks.count(c) == 3 }
    [4, three_of_kind] if three_of_kind
  end

  def two_pair_score(cards, ranks, set)
    two_pairs = set.find_all { |c| ranks.count(c) == 2 }
    [3] + two_pairs.sort.reverse if two_pairs.count == 2
  end

  def pair_score(cards, ranks, set)
    pair = set.find_all { |c| ranks.count(c) == 2 }
    [2] + pair if pair.count == 1
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

  end
end
