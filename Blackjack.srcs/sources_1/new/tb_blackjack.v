`timescale 1ns / 1ps


module tb_blackjack;
    
    reg Clk = 1'b0, 
        Rst = 1'b0, 
        Hit = 1'b0, 
        Stand = 1'b0, 
        Restart = 1'b0;
    wire Win, Lose, Draw;
    
    localparam period = 0.5;    // duration for each bit of the clock, 100MHz clock
    blackjack UUT(.Clk(Clk), .Rst(Rst), .Hit(Hit), .Stand(Stand), .Restart(Restart), .Win(Win), .Lose(Lose), .Draw(Draw));
    
    
    // Create fake clock
    always
    begin
        Clk = 1'b0;
        #period;
        
        Clk = 1'b1;
        #period;
    end 
    
    // Move across statemachine
    always @(posedge Clk)
    begin
        Hit = 1'b1;
        #20;    // wait 20ns
        
        Hit = 1'b0;
        #20;
    
        Stand = 1'b1;
        #period;
        
        Stand = 1'b0;
        Rst = 1'b1;
        #10;
        
        Rst = 1'b0;
    
    end
    
endmodule
