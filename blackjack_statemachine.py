import random
from statemachine import StateMachine, State

class BlackJackMachine(StateMachine):

    # Create states
    initState = State("init", initial=True)
    userState = State("user_turn")
    dealerState = State("dealer_turn")
    scoreState = State("final_scores")
    exitState = State("exit", final=True)

    # Transition to next states
    switchUser = initState.to(userState)
    switchDealer = userState.to(dealerState)
    switchScore = dealerState.to(scoreState)
    switchInit = scoreState.to(initState)
    switchExit = scoreState.to(exitState)



def main():
    bj = BlackJackMachine()
    while bj.current_state.id != 'exitState':
        if bj.current_state.id in ['initState', 'userState']:
            print(f'Dealer\'s current hand: {dealer_score}')
            print(f'User\'s current hand: {user_score}')
            decision = input("Hit or stand (hit/stand): ")


            if bj.current_state.id == 'initState':
                # Set initial score of user and dealer each new game
                user_score = random.randint(1,21)
                dealer_score = random.randint(1,21)

                # User decides if they want to hit or stand
                decision = input("Hit or stand (hit/stand): ")
                print(f'You entered: {decision}\n')
                if decision == "hit" or decision == "stand":
                    bj.switchUser()
                else:
                    print('Invalid decision\n')

            elif bj.current_state.id == 'userState':
                # Increment user's score if they want to hit
                # Else, dealer's turn
                print('here', decision)
                if decision == "hit":
                    print('incrementing')
                    user_score+=random.randint(1,10)
                else:
                    bj.switchDealer()

        elif bj.current_state.id == 'dealerState':
            # If user didn't bust, draw card until dealer gets close to 21
            if user_score < 21:
                while dealer_score <= 17:
                    dealer_score+=random.randint(1,10)
            bj.switchScore()
        
        elif bj.current_state.id == 'scoreState':
            # Check if user won or not
            if user_score > 21:
                print('You Busted!')
            else:
                if user_score < dealer_score and dealer_score <= 21:
                    print('Dealer won!')
                elif user_score > dealer_score or dealer_score > 21:
                    print('You won!')
                elif user_score == dealer_score:
                    print('Draw')

            # Print specific scores
            print('Final score:')
            print(f'Dealer\'s final score: {dealer_score}')
            print(f'User\'s final score: {user_score}\n')

            resume = input('Play again? Enter any key or enter \'n\' to quit: ')
            if resume == 'n':
                bj.switchExit()
            else:
                bj.switchInit()
        
if __name__ == "__main__":
    main()