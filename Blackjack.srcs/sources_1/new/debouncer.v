`timescale 1ns / 1ps
 
 // ------- Debounce Module ------- //
module debouncer(
    input pb_1,
    input clk,
    output reg pb_out
    );

wire slow_clk;
//wire slow_clk2;
wire Q0, Q1, Q2, Q2_bar;

clock_div u1(clk,slow_clk);
//clock_div2 u2(clk, slow_clk2);
dff d0(slow_clk, pb_1, Q0);
dff d1(slow_clk, Q0, Q1);
//dff d2(slow_clk2, Q1, Q2);
dff d2(slow_clk, Q1, Q2);

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
        counter <= (counter >= 350)?0:counter+1;
        slow_clk <= (counter < 175)?1'b0:1'b1;
    end
endmodule

// D Flip-Flop
module dff(
    input clk,
    input d,
    output reg q
    );

    always @(clk)
    begin
        q <= d;
    end
endmodule

//module clock_div2(
//    input clk_100M,
//    output reg slow_clk
//    );

//    reg [26:0] counter = 0;
//    always @(posedge(clk_100M))
//    begin
//        counter <= (counter >= 4)?0:counter+1;
//        slow_clk <= (counter < 2)?1'b0:1'b1;
//    end
//endmodule
