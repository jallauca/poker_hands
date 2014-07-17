##poker_hands

This is a solution to the poker problem from coder dojo
(http://cyber-dojo.org/setup/show/1E8447)

## Getting Started
1. Run the tests and make sure the latest version passes all tests

        $ ./poker --tests

2. Run poker with some input

*Two poker hands with 5 cards*

        $ ./poker "Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH"
        White wins - High Card

*Multiple poker hands with 5 cards*

        $ ./poker "Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH Green: 2S 2D 2C 3D 4D"
        Green wins - Three of a Kind

*Multiple poker hands with more than 5 cards*

        $ ./poker "Black: 2C JC 3H JD 3S JS 2D White: QH QD 10D JD QD KD AD"
        White wins - Straight Flush

*Multiple poker hands in Texas Hold'em style of poker*

        $ ./poker "House: QH QD JC 3H JD Black: 3S TS White: KD AD Green: QS QD"
        Green wins - Four of a Kind
