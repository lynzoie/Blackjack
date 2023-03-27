`timescale 1ns / 1ps

module blackjack(
    input Clk,
    input Rst,
    input Hit,
    input Stand,
    output Win,
    output Lose,
    output Draw,
    output [1:0] State_LED,
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
    
    reg hit_before;
    reg hit_after = 1'b0;
    reg hit_pulse;

    reg stand_before;
    reg stand_after = 1'b0;
    reg stand_pulse;

    reg rst_before;
    reg rst_after = 1'b0;
    reg rst_pulse;

    // Wires
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
    wire [4:0] user_score_wire;
    wire [4:0] dealer_score_wire;
    wire [4:0] user_rand_inc;
    wire [4:0] dealer_rand_inc;

    random_num_gen #(.START_VAL(12)) rand_user(.clock(Clk),
        .val_limit(21),
        .rnd(user_score_wire)
    );

    random_num_gen #(.START_VAL(16)) rand_dealer(.clock(Clk),
        .val_limit(21),
        .rnd(dealer_score_wire)
    );

    random_num_gen #(.START_VAL(9)) rand_user_inc(.clock(Clk),
        .val_limit(10),
        .rnd(user_rand_inc)
    );

    random_num_gen #(.START_VAL(4)) rand_dealer_inc(.clock(Clk),
        .val_limit(10),
        .rnd(dealer_rand_inc)
    );

    // ------------------ MAIN MODULE------------------- //

    // Pulse hit, stand, and rst reg
    always @ (posedge Clk) 
    begin
        // Create hit pulse
        hit_before <= hit_reg;
        hit_after <= hit_before;
        if (hit_before != hit_after && hit_before) 
        begin
            hit_pulse <= 1'b1;
        end
        else
        begin
            hit_pulse <= 1'b0;
        end

        // Create Stand pulse
        stand_before <= stand_reg;
        stand_after <= stand_before;
        if (stand_before != stand_after && stand_before) 
        begin
            stand_pulse <= 1'b1;
        end
        else
        begin
            stand_pulse <= 1'b0;
        end

        // Create Rst pulse
        rst_before <= rst_reg;
        rst_after <= rst_before;
        if (rst_before != rst_after && rst_before) 
        begin
            rst_pulse <= 1'b1;
        end
        else
        begin
            rst_pulse <= 1'b0;
        end
    end

    // Set initial values
    always @ (posedge Clk)
    begin
        // go to state zero if reset
        if (rst_pulse) 
        begin
            cur_state <= initState;
        end
        else
        begin
            cur_state <= next_state;
        end
    end

    // Statemachine
     always @ (posedge Clk) 
     begin
         next_state = cur_state;
         case(cur_state) 
             initState: 
             begin
                 // Randomize user_score and dealer_score
                 // user_score = {$random} % 22;
                 // dealer_score = {$random} % 22;
                 user_score = user_score_wire;
                 dealer_score = dealer_score_wire;

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
                 if (stand_pulse || user_score == 21 || dealer_score == 21 || user_score > 21) 
                 begin
                     next_state = dealerState;
                 end
                 else if (hit_pulse)
                 begin
                     // Increment score by random number between 1-10
                     // user_score = user_score + {$random} % 11;
                     user_score = user_score + user_rand_inc;
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
                     dealer_score = dealer_score + dealer_rand_inc;
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
                 if (rst_pulse) 
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
    
    assign State_LED = cur_state;
endmodule


