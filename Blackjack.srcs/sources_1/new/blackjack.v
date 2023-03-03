`timescale 1ns / 1ps

module top_blackjack(
    input Clk,
    input Rst,
    input Hit,
    input Stand
    );
    
    integer dealer_score = 0;   // Dealer's current score
    integer user_score = 0;     // User's current score
    
    // Internal constants
    parameter C_SIZE = 2;

    // State instantiations
    localparam [C_SIZE-1:0]
            initState = 2'b00,
            userState = 2'b01,
            dealerState = 2'b10,
            scoreState = 2'b11,

    reg [C_SIZE-1:0] cur_state, next_state;

    always @(posedge(Clk), posedge(Rst)) 
    begin
        next_state = cur_state
        case(cur_state)
            initState: begin
                // randomize dealer_score and user_score
                next_state = userState;
            end
            userState: begin
                // do stuff
            end
            dealerState: begin
                // do stuff
            end
            scoreState: begin
                // do stuff
            end
            default: next_state = initState;
    
    end 
    

endmodule
