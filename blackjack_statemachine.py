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
    decision = ''
    while bj.current_state.id != 'exitState':

        if bj.current_state.id == 'initState':
            # Set initial score of user and dealer each new game
            user_score = random.randint(1,21)
            dealer_score = random.randint(1,21)
            
            # Start game
            bj.switchUser()

        elif bj.current_state.id == 'userState':

            # User decides if they want to hit or stand
            decision = input("Hit or stand (hit/stand): ")
            print(f'You entered: {decision}\n')

            # If user wants to stand or already receives 21, switch to dealer
            if decision == "stand" or user_score == 21:
                bj.switchDealer()
            elif decision == "hit":
                # Increment user's score if they want to hit
                user_score+=random.randint(1,10)
                # If user already busts, switch to dealer
                if user_score > 21:
                    bj.switchDealer()
            else:
                print('Invalid decision\n')

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

            resume = input('Play again? Enter any key or enter \'n\' to quit: ')
            if resume == 'n':
                bj.switchExit()
            else:
                bj.switchInit()

        print(f'Dealer\'s current hand: {dealer_score}')
        print(f'User\'s current hand: {user_score}\n')
        
if __name__ == "__main__":
    main()