`timescale 1ns / 1ps


module tb_blackjack;
    
    reg Clk = 1'b0, 
        Rst = 1'b0, 
        Hit = 1'b0, 
        Stand = 1'b0;        
    wire Win, Lose, Draw;
    wire [3:0] Anode_Activate;
    wire [6:0] LED_out;

    localparam period = 0.5;    // duration for each bit of the clock, 100MHz clock
    blackjack UUT(.Clk(Clk), 
        .Rst(Rst), 
        .Hit(Hit), 
        .Stand(Stand), 
        .Win(Win), 
        .Lose(Lose), 
        .Draw(Draw),
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
    
    // Win Case
    initial
    begin
        #100;
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
        
        // Hit 2        
        #300;
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
         
        // Hit 3
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
        
        // Hit 4 
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
    
    // Restart button
    initial 
    begin
        // Rst 1 
        #12000;
        Rst = 0;
        #10;
        Rst = 1;
        #20;
        Rst = 0;
        #10;
        Rst = 1;
        #30; 
        Rst = 0;
        #10;
        Rst = 1;
        #40;
        Rst = 0;
        #10;
        Rst = 1;
        #30; 
        Rst = 0;
        #10;
        Rst = 1; 
        #1000; 
        Rst = 0;
        #10;
        Rst = 1;
        #20;
        Rst = 0;
        #10;
        Rst = 1;
        #30; 
        Rst = 0;
        #10;
        Rst = 1;
        #40;
        Rst = 0;
    end
    
    
    
endmodule
