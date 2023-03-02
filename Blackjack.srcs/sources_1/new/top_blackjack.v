`timescale 1ns / 1ps

module top_blackjack(
    input Clk,
    input Rst,
    input Btn
    );
    
    integer dealer_score = 0;   // Dealer's current score
    integer user_score = 0;     // User's current score
    
    
    always @(posedge(Clk)) 
    begin
    
    end 
    

endmodule
