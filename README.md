##poker_hands

This is a solution to the poker problem from coder dojo
(http://cyber-dojo.org/setup/show/1E8447)

## Getting Started
1. Run the tests and make sure the latest version passes all tests

        $ ./poker --tests

2. Run poker with some input

        $ ./poker "Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH"
        White - High Card wins

        $ ./poker "Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH Green: 2S 2D 2C 3D 4D"
        Green - Three of a Kind wins

        $ ./poker "Black: 2C JC 3H JD 3S JS 2D White: QH QD 10D JD QD KD AD"
        White - Straight Flush wins

## Code Status
This particular solution is able to determine the poker winner
from the following input data:

1. Two poker hands with 5 cards
2. Multiple poker hands with 5 cards
3. Multiple poker hands with more than 5 cards
