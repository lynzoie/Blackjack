`timescale 1ns / 1ps


module tb_blackjack;
    
    reg Clk = 1'b0, 
        Rst = 1'b0, 
        Hit = 1'b0, 
        Stand = 1'b0;
    wire Win, Lose, Draw;
    
    localparam period = 0.5;    // duration for each bit of the clock, 100MHz clock
    blackjack UUT(.Clk(Clk), .Rst(Rst), .Hit(Hit), .Stand(Stand), .Win(Win), .Lose(Lose), .Draw(Draw));
    
    
    // Create fake clock
    always
    begin
        Clk = 1'b0;
        #period;
        
        Clk = 1'b1;
        #period;
    end 
    
    // Create fake button push 
    initial
    begin
        #1201;
        Hit = 0;
        #10;
        Hit=1;
        #20;
        Hit = 0;
        #10;
        Hit=1;
        #30; 
        Hit = 0;
        #10;
        Hit=1;
        #40;
        Hit = 0;
        #10;
        Hit=1;
        #30; 
        Hit = 0;
        #10;
        Hit=1; 
        #1000; 
        Hit = 0;
        #10;
        Hit=1;
        #20;
        Hit = 0;
        #10;
        Hit=1;
        #30; 
        Hit = 0;
        #10;
        Hit=1;
        #40;
        Hit = 0; 
    end 
    
//    // Move across statemachine
//    always @(posedge Clk)
//    begin
//        Hit = 1'b1;
//        #20;    // wait 20ns
        
//        Hit = 1'b0;
//        #20;
    
//        Stand = 1'b1;
//        #period;
        
//        Stand = 1'b0;
//        Rst = 1'b1;
//        #10;
        
//        Rst = 1'b0;
    
//    end
    
endmodule
