`timescale 1ns / 1ps

module top_blackjack(
    input Clk,
    input Reset,
    input Hit,
    input Stand,
    output Win,
    output Lose,
    output Draw,
    output Hit_LED,
    output Reset_LED,
    output Stand_LED,
    output [1:0] State_LED,
    // 7-seg output
    output [3:0] Anode_Activate,
    output [6:0] LED_out
    );
    
    // Map real buttons to blackjack module
    blackjack bj(.Clk(Clk),
        .Rst(Reset),
        .Hit(Hit),
        .Stand(Stand),
        .Win(Win),
        .Lose(Lose),
        .Draw(Draw),
        .State_LED(State_LED),
        .Anode_Activate(Anode_Activate),
        .LED_out(LED_out)
    ); 
    
    assign Hit_LED = Hit;
    assign Reset_LED = Reset;
    assign Stand_LED = Stand;

endmodule
