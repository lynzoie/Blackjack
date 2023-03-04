`timescale 1ns / 1ps


// TODO: need to work on 7 segment display variables

module blackjack(
    input Clk,
    input Rst,
    input Hit,
    input Stand,
    input Restart,
    output Win,
    output Lose,
    output Draw
    );
    
    integer dealer_score = 18;   // Dealer's current score
    integer user_score = 0;     // User's current score
    
    // Internal constants
    parameter C_SIZE = 2;

    // State instantiations
    localparam [C_SIZE-1:0]
            initState = 2'b00,
            userState = 2'b01,
            dealerState = 2'b10,
            scoreState = 2'b11;

    reg [C_SIZE-1:0] cur_state, next_state;


    // Set initial values
    always @(posedge(Clk), posedge(Rst))
    begin
        if (Rst)    // go to state zero if reset
        begin
            cur_state <= initState;
        end
        else
        begin
            cur_state <= next_state;
        end
    end


    // Statemachine
    always @(posedge(Clk), posedge(Rst)) 
    begin
        next_state = cur_state;
        case(cur_state) 
            initState: begin
                // randomize dealer_score and user_score
                // display on 7-segment display
                next_state = userState;
            end
            userState: begin
                // if user hits, keep going
                // else, switch to dealer's turn
                // update on 7-seg display
                if (Stand) begin
                    next_state = dealerState;
                end
            end
            dealerState: begin
                // increment dealer's score until it reaches 17 or below
                // update on 7-seg display
                if (dealer_score > 17) begin
                    next_state = scoreState;
                end
            end
            scoreState: begin
                // display scores
                if (Restart) begin
                    next_state = initState;
                end
            end
            default: begin
                next_state = initState;
            end
        endcase
    end 
    

endmodule
