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
    always @ (posedge Rst)
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
    always @ (posedge Clk) 
    begin
        next_state = cur_state;
        case(cur_state) 
            initState: 
            begin
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

    // -------- 7-segment section --------------//
    integer onesDigit = 0;
    integer twosDigit = 0;
    integer threesDigit = 0;
    integer foursDigit = 0;
    integer refresh_counter = 0;
    integer LED_activating_counter = 0;
    reg [3:0] Anode_Activate_Var;
    reg [6:0] LED_out_Var;
    reg [3:0] LED_BCD;
    
    // Declare the digits for display
    always @(posedge(Clk))
    begin
        // Dealer's score
        foursDigit = dealer_score / 10;
        threesDigit = dealer_score % 10;
        // User's score
        twosDigit = user_score / 10;
        onesDigit = user_score % 10;
    end
    
    // Activate one of four 7-seg displays
    always @(posedge(Clk))
    begin 
        refresh_counter = refresh_counter + 1;      //increment counter
        if(refresh_counter == 5000)                 //at 500
            LED_activating_counter = 0;             //light onesDigit
        if(refresh_counter == 10000)                //at 1,000
            LED_activating_counter = 1;             //light twosDigit
        if(refresh_counter == 15000)                //at 1,500
            LED_activating_counter = 2;             //light threesDigit
        if(refresh_counter == 20000)                //at 20,000
            LED_activating_counter = 3;             //light foursDigit
        if(refresh_counter == 25000)                //at 25,000
            refresh_counter = 0;                    //start over at 0
    end


    always @(LED_activating_counter, foursDigit, threesDigit, twosDigit, onesDigit)                    //when 7-seg digit changes
    begin
        //LED_activating_counter = refresh_counter;
        case(LED_activating_counter)                    //activate the digit
            0: begin
                Anode_Activate_Var = 4'b0111;           //activate LED1 and Deactivate LED2, LED3, LED4
                LED_BCD = foursDigit;                   //the first digit of the 16-bit number
            end
            1: begin
                Anode_Activate_Var = 4'b1011;           //activate LED2 and Deactivate LED1, LED3, LED4
                LED_BCD = threesDigit;                  //the second digit of the 16-bit number
            end
            2: begin
                Anode_Activate_Var = 4'b1101;           // activate LED3 and Deactivate LED2, LED1, LED4
                LED_BCD = twosDigit;                    // the third digit of the 16-bit number
            end
            3: begin
                Anode_Activate_Var = 4'b1110;           // activate LED4 and Deactivate LED2, LED3, LED1
                LED_BCD = onesDigit;                    // the fourth digit of the 16-bit number 
            end
        endcase
    end


    always @(LED_BCD)
    begin
        case(LED_BCD)
            4'b0000: LED_out_Var = 7'b0000001; // "0"     
            4'b0001: LED_out_Var = 7'b1001111; // "1" 
            4'b0010: LED_out_Var = 7'b0010010; // "2" 
            4'b0011: LED_out_Var = 7'b0000110; // "3" 
            4'b0100: LED_out_Var = 7'b1001100; // "4" 
            4'b0101: LED_out_Var = 7'b0100100; // "5" 
            4'b0110: LED_out_Var = 7'b0100000; // "6" 
            4'b0111: LED_out_Var = 7'b0001111; // "7" 
            4'b1000: LED_out_Var = 7'b0000000; // "8"     
            4'b1001: LED_out_Var = 7'b0000100; // "9" 
            default: LED_out_Var = 7'b0000001; // "0"
        endcase
    end

    assign Anode_Activate = Anode_Activate_Var;
    assign LED_out = LED_out_Var;

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
