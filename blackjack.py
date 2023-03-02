# Testing logic for Blackjack project
from statemachine import StateMachine, State
import random 


resume = ""
print("Welcome to PyBlackJack! Dealer stands at hard 18")

while resume != "n":
    decision = ""
    user_score = random.randint(1,21)
    dealer_score = random.randint(1,21)
    while decision != "stand" and user_score < 21:
        # Print current score of dealer and user
        print(f'Dealer\'s current hand: {dealer_score}')
        print(f'User\'s current hand: {user_score}')

        # User decides if they want to hit or stand
        decision = input("Hit or stand (hit/stand): ")
        print(f'You entered: {decision}\n')

        if decision == "hit":
            # Increment user's score if they want to hit
            user_score+=random.randint(1,10)
        elif decision == "stand":
            # Dealer's turn
            if user_score < 21:
                while dealer_score <= 17:
                    dealer_score+=random.randint(1,10)
        else:
            # Error checks user's input
            print('Invalid decision\n')

    if user_score > 21:
        print('You Busted!')
    else:
        if user_score < dealer_score and dealer_score <= 21:
            print('Dealer won!')
        elif user_score > dealer_score or dealer_score > 21:
            print('You won!')
        elif user_score == dealer_score:
            print('Draw')
        
    print('Final score:')
    print(f'Dealer\'s final score: {dealer_score}')
    print(f'User\'s final score: {user_score}\n')

    resume = input('Play again? Enter any key or enter \'n\' to quit: ')