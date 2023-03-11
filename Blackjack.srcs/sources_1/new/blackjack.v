`timescale 1ns / 1ps


// TODO: need to work on 7 segment display variables

// TODO: check if randomizing variable to add to dealer_score and user_score
// is accurate, may be due to issues with signed/unsigned integers
module blackjack(
    input Clk,
    input Rst,
    input Hit,
    input Stand,
    output Win,
    output Lose,
    output Draw
    );

    // -------------- INITIALIZATION --------------//
    // Internal constants
    parameter C_SIZE = 2;

    // State instantiations
    localparam [C_SIZE-1:0]
            initState = 2'b00,
            userState = 2'b01,
            dealerState = 2'b10,
            scoreState = 2'b11;
    reg [C_SIZE-1:0] cur_state, next_state;


    // Debounced input
    debounce db_rst(Rst, Clk, rst_reg);
    debounce db_hit(Hit, Clk, hit_reg);
    debounce db_stand(Stand, Clk, stand_reg);

    // Output reg
    reg win_reg;
    reg lose_reg;
    reg draw_reg;

    // Dealer and User's scores
    integer dealer_score;
    integer user_score;

    // Set initial values
    always @(posedge(Clk), posedge(Rst))
    begin
        // go to state zero if reset
        if (rst_reg) 
        begin
            cur_state <= initState;
        end
        else
        begin
            cur_state <= next_state;
        end
    end


    // ------------- START OF MODULES -------------//
    // ------- Statemachine ------- //
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
                win_reg     = 1'b0;
                lose_reg    = 1'b0;
                draw_reg    = 1'b0;

                // Switch to userState after randomization
                next_state = userState;
            end
            userState: 
            begin
                // TODO: update on 7-seg display

                // If randomized score is already 21 or first choice is hit
                // switch to dealerState
                if (stand_reg || user_score == 21 || dealer_score == 21) 
                begin
                    next_state = dealerState;
                end
                else if (hit_reg)
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
                    win_reg     = 1'b0;
                    lose_reg    = 1'b1;
                    draw_reg    = 1'b0;
                end
                else if ((user_score > dealer_score && user_score <= 21) || dealer_score > 21)
                begin 
                    win_reg     = 1'b1;
                    lose_reg    = 1'b0;
                    draw_reg    = 1'b0;
                end 
                else 
                begin
                    win_reg     = 1'b0;
                    lose_reg    = 1'b0;
                    draw_reg    = 1'b1;
                end 

                // If user wants to play again, reset at initState
                if (rst_reg) 
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
    
    assign Win = win_reg;
    assign Lose = lose_reg;
    assign Draw = draw_reg;

endmodule

// ------- Debounce Module ------- //
module debounce(
    input pb_1,
    input clk,
    output reg pb_out
    );

wire slow_clk;
wire Q0, Q1, Q2, Q2_bar;

clock_div u1(clk,slow_clk);
dff d0(slow_clk, pb_1, Q0);
dff d1(slow_clk, Q0, Q1);
dff d2(clk, Q1, Q2);

assign Q2_bar = ~Q2;

always @(*)
begin
    pb_out = Q1 & Q2_bar;
end

endmodule

// ----- Debounce Submodules ----- //
// Slow clock
module clock_div(
    input clk_100M,
    output reg slow_clk
    );

    reg [26:0] counter = 0;
    always @(posedge(clk_100M))
    begin
        counter <= (counter >= 249)?0:counter+1;
        slow_clk <= (counter < 125)?1'b0:1'b1;
    end
endmodule

// D Flip-Flop
module dff(
    input clk,
    input d,
    output reg q
    );

    always @(posedge(clk))
    begin
        q <= d;
    end
endmodule