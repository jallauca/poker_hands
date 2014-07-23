require 'set'
require 'underscore'

module Poker
  class << self

  def find_winner(input)
    poker_game = Underscore.methods_compose_right(self,
        :parse, :validate, :combine_for_texas_hold_em,
        :best_hand_combination, :get_scores,
        :sort_hands, :get_winners)
    poker_game[ input ]
  end

  private

  def parse(input)
    split_hands = input.scan(/\w+:(?:\s[0-9TAJKQ][HDSC])*/)
    split_hands.reduce({ }) do |hash, hand|
      name, cards = hand.split(":")
      hash[name] = cards.strip.split(" ")
      hash
    end
  end

  def validate(hands)
    valid_hands = hands.values.map(&:length).all? { |c| [2,5,7].include? c }
    raise ArgumentError, "Invalid hand count" unless valid_hands
    hands
  end

  def best_hand_combination(hands)
    card_by_score = ->(c) { [get_score(c), c] }
    hands.reduce({ }) do |hash, (hand, cards)|
      _, best_cards = cards.combination(5).map(&card_by_score).max
      hash[hand] = best_cards
      hash
    end
  end

  def sort_hands(hand_scores)
    desc_hand_comparison = ->(h1, h2) { h2[1] <=> h1[1] }
    hands_by_score_desc = hand_scores.sort(&desc_hand_comparison)
  end

  def get_winners(hands_by_score_desc)
    first_hand, first_score = hands_by_score_desc.first
    winners = hands_by_score_desc.take_while { |hand, score| score == first_score }
    return get_multiple_winners(winners) if winners.count > 1

    get_winner(hands_by_score_desc)
  end

  def find_high_card(first_score, second_score)
    return nil if first_score[0] > second_score[0]
    high_card, _ = first_score.each_with_index.find do |c, i|
      c > second_score[i] && i > 0
    end
    high_card
  end

  def get_multiple_winners(winners)
    winners_string =  winners.map { |w| w[0] }.join(', ')
    "#{winners_string} - Tie"
  end

  def get_winner(hands_by_score_desc)
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
      memo[name] = get_score(cards)
      memo
    end
  end

  def get_score(cards)
    ranks = get_ranks(cards)
    set = Set.new(ranks)

    ranking = straight_flush_ranking(cards, ranks, set) ||
              four_of_kind_ranking(cards, ranks, set) ||
              full_house_ranking(cards, ranks, set) ||
              flush_ranking(cards, ranks, set) ||
              straight_ranking(cards, ranks, set) ||
              three_of_kind_ranking(cards, ranks, set) ||
              two_pair_ranking(cards, ranks, set) ||
              pair_ranking(cards, ranks, set) ||
              [1]

    return ranking + ranks
  end

  def indexed_cards
    @indexed_cards ||=
      Hash[ "--23456789TJQKA".chars.each_with_index.map { |n, i| [n, i] } ]
  end

  def indexed_cards_inverse
    indexed_cards.reduce({ }) { |hash, (k, v)| hash[v] = k; hash }
  end

  def rankings
    @rankings ||=
      ["","","Pair","Two Pairs","Three of a Kind","Straight","Flush",
       "Full House","Four of a Kind","Straight Flush"]
  end

  def get_ranks(cards)
    cards = cards.map { |c| indexed_cards[ c[0..-2] ] }.sort.reverse
    return [5,4,3,2,1] if cards == [14,5,4,3,2]
    cards
  end

  def get_play_label(score)
     rankings[score[0]]
  end

  def straight_flush_ranking(cards, ranks, set)
    ranking1 = straight_ranking(cards, ranks, set)
    ranking2 = flush_ranking(cards, ranks, set)
    [9] if ranking1 && ranking2
  end

  def four_of_kind_ranking(cards, ranks, set)
    four_of_kind = set.find { |c| ranks.count(c) == 4 }
    [8, four_of_kind] if four_of_kind
  end

  def full_house_ranking(cards, ranks, set)
    three_of_kind = set.find { |c| ranks.count(c) == 3 }
    two_of_kind = set.find { |c| ranks.count(c) == 2 }
    [7, three_of_kind, two_of_kind] if three_of_kind && two_of_kind
  end

  def flush_ranking(cards, ranks, set)
    suits = Set.new( cards.map { |c| c[-1] } )
    [6] if suits.count == 1
  end

  def straight_ranking(cards, ranks, set)
    [5] if set.count == 5 && (ranks[0] - ranks[-1]) == 4
  end

  def three_of_kind_ranking(cards, ranks, set)
    three_of_kind = set.find { |c| ranks.count(c) == 3 }
    [4, three_of_kind] if three_of_kind
  end

  def two_pair_ranking(cards, ranks, set)
    two_pairs = set.find_all { |c| ranks.count(c) == 2 }
    [3] + two_pairs.sort.reverse if two_pairs.count == 2
  end

  def pair_ranking(cards, ranks, set)
    pair = set.find_all { |c| ranks.count(c) == 2 }
    [2] + pair if pair.count == 1
  end

  def combine_for_texas_hold_em(hands)
    new_hands = hands.clone
    house = new_hands.delete("House")
    new_hands.each { |hand, cards| new_hands[hand] = cards + house } if house
    new_hands
  end

  end
end
