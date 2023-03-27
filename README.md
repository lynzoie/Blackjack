# Blackjack

The following project works on the Basys 3 board. 

##  Button assignments:
- Hit - `BTNL`
- Stand - `BTNR`
- Rst/Restart - `BTNC`

## LED Assignments:
- Win - `U16`
- Lose - `U19`
- Draw - `E19`

- Hit - `L1`
- Stand - `N3`
- Rst/Restart - `P1`

States are displayed in LED order [`LD8`, `LD7`]
00 - Init (will probably never see this state)
01 - User's turn (user can choose to hit to stay in turn, or stand to end turn)
10 - Dealer's turn (will probably never see this state)
11 - Score's state (user must choose to restart to play again)