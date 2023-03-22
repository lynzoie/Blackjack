`timescale 1ns / 1ps

module blackjack(
    input Clk,
    input Rst,
    input Hit,
    input Stand,
    output Win,
    output Lose,
    output Draw,
    // 7-seg output
    output [3:0] Anode_Activate,
    output [6:0] LED_out
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

    // Registers
    reg [C_SIZE-1:0] cur_state = initState;
    reg [C_SIZE-1:0] next_state;
    reg win_reg;
    reg lose_reg;
    reg draw_reg;
    wire [3:0] anode_activate_reg;
    wire [6:0] led_out_reg;

    // Dealer and User's scores
    integer dealer_score;
    integer user_score;


    // --- Module Instantiations ---//
    // Seven Segment Display
    seven_seg sev_disp(.Clk(Clk),
        .user_score(user_score),
        .dealer_score(dealer_score),
        .Anode_Activate(anode_activate_reg),
        .LED_out(led_out_reg)
    );

    // Debounced input
    debouncer db_rst(Rst, Clk, rst_reg);
    debouncer db_hit(Hit, Clk, hit_reg);
    debouncer db_stand(Stand, Clk, stand_reg);

    // Randomized value
    wire [4:0] user_score_test;
    wire [4:0] dealer_score_test;
    wire [4:0] user_rand_inc_test;
    wire [4:0] dealer_rand_inc_test;

    random_num_gen #(.START_VAL(10)) rand_user(.clock(Clk),
        .val_limit(21),
        .rnd(user_score_test)
    );

    random_num_gen #(.START_VAL(14)) rand_dealer(.clock(Clk),
        .val_limit(21),
        .rnd(dealer_score_test)
    );

    random_num_gen #(.START_VAL(9)) rand_user_inc(.clock(Clk),
        .val_limit(10),
        .rnd(user_rand_inc_test)
    );

    random_num_gen #(.START_VAL(4)) rand_dealer_inc(.clock(Clk),
        .val_limit(10),
        .rnd(dealer_rand_inc_test)
    );

    // TODO: work on putting the random num generators in here
    // ------------------ MAIN MODULE------------------- //
    // Set initial values
    always @ (posedge Clk)
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

    always @ (posedge Clk) 
    begin
        next_state = cur_state;
        case(cur_state) 
            initState: 
            begin
                // Randomize user_score and dealer_score
                // user_score = {$random} % 22;
                // dealer_score = {$random} % 22;
                user_score = user_score_test;
                dealer_score = dealer_score_test;

                // Reset outcome
                win_reg     = 1'b0;
                lose_reg    = 1'b0;
                draw_reg    = 1'b0;

                // Switch to userState after randomization
                if (user_score > 0 && dealer_score > 0)
                begin
                    next_state = userState;
                end
            end
            userState: 
            begin
                // If randomized score is already 21 or first choice is hit
                // switch to dealerState
                if (stand_reg || user_score == 21 || dealer_score == 21 || user_score > 21) 
                begin
                    next_state = dealerState;
                end
                else if (hit_reg)
                begin
                    // Increment score by random number between 1-10
                    // user_score = user_score + {$random} % 11;
                    user_score = user_score + user_rand_inc_test;
                end
            end
            dealerState: 
            begin
                if (dealer_score > 17 || user_score >= 21) 
                begin
                    next_state = scoreState;
                end
                else
                begin
                    // Increment dealer's score until it reaches 17 or below
                    // dealer_score = dealer_score + {$random} % 11;
                    dealer_score = dealer_score + dealer_rand_inc_test;
                end
            end
            scoreState: 
            begin
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

    assign Anode_Activate = anode_activate_reg;
    assign LED_out = led_out_reg;

endmodule


