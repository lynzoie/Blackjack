`timescale 1ns / 1ps


module tb_seven_seg;
    // Module inputs
    reg Clk = 1'b0;
    reg [4:0] user_score;
    reg [4:0] dealer_score;
    
    // Module outputs
    wire [3:0] Anode_Activate;
    wire [6:0] LED_out;
    
    localparam period = 0.5;
    seven_seg UUT(.Clk(Clk),
        .user_score(user_score),
        .dealer_score(dealer_score),
        .Anode_Activate(Anode_Activate),
        .LED_out(LED_out)
        );
      
    // Create fake clock  
    always
    begin
        Clk = 1'b0;
        #period;
        Clk = 1'b1;
        #period;
    end

    // Change user_ and dealer_score
    always
    begin
        user_score = 13;
        dealer_score = 21;
        #100;
        user_score = 4;
        dealer_score = 10;
        #100;
        user_score = 0;
        dealer_score = 9;
        #100;
        user_score = 21;
        dealer_score = 21;
        #100;
        user_score = 0;
        dealer_score = 0;
        #100;
    end
        

endmodule
