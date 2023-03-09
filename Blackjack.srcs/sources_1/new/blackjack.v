`timescale 1ns / 1ps


// TODO: need to work on 7 segment display variables

// TODO: check if randomizing variable to add to dealer_score and user_score
// is accurate, may be due to issues with signed/unsigned integers
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
    
    integer dealer_score = 0 ;   // Dealer's current score
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

    // Output reg
    reg Win_Reg;
    reg Lose_Reg;
    reg Draw_Reg;

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
            initState: 
            begin
                // TODO: display on 7-segment display

                // Randomize user_score and dealer_score
                user_score = {$random} % 22;
                dealer_score = {$random} % 22;

                // Reset outcome
                Win_Reg     = 1'b0;
                Lose_Reg    = 1'b0;
                Draw_Reg    = 1'b0;

                // Switch to userState after randomization
                next_state = userState;
            end
            userState: 
            begin
                // TODO: update on 7-seg display

                // If randomized score is already 21 or first choice is hit
                // switch to dealerState
                if (Stand || user_score == 21 || dealer_score == 21) 
                begin
                    next_state = dealerState;
                end
                else if (Hit)
                begin

                    // If user already busts, switch to dealer
                    if (user_score >= 21)
                    begin
                        next_state = dealerState;
                    end
                    else
                    begin
                        // Increment score by random number between 1-10
                        user_score = user_score + {$random} % 11;
                    end
                end
            end
            dealerState: 
            begin
                // TODO: update on 7-seg display

                if (dealer_score > 17 || user_score >= 21) 
                begin
                    next_state = scoreState;
                end
                else
                begin
                    // Increment dealer's score until it reaches 17 or below
                    dealer_score = dealer_score + {$random} % 11;
                end
            end
            scoreState: 
            begin
                // TODO: display scores on 7-seg display

                // Display if User won, lost, or drew
                if ((user_score < dealer_score && dealer_score <= 21) || user_score > 21)
                begin
                    Win_Reg     = 1'b0;
                    Lose_Reg    = 1'b1;
                    Draw_Reg    = 1'b0;
                end
                else if ((user_score > dealer_score && user_score <= 21) || dealer_score > 21)
                begin 
                    Win_Reg     = 1'b1;
                    Lose_Reg    = 1'b0;
                    Draw_Reg    = 1'b0;
                end 
                else 
                begin
                    Win_Reg     = 1'b0;
                    Lose_Reg    = 1'b0;
                    Draw_Reg    = 1'b1;
                end 

                // If user wants to play again, restart at initState
                if (Restart) 
                begin
                    next_state = initState;
                end
            end
            default: 
            begin
                next_state = initState;
            end
        endcase
    end 
    
    assign Win = Win_Reg;
    assign Lose = Lose_Reg;
    assign Draw = Draw_Reg;

endmodule
