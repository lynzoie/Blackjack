`timescale 1ns / 1ps
 
 // ------- Debounce Module ------- //
module debouncer(
    input pb_1,
    input clk,
    output pb_out
    );

wire slow_clk;
wire Q0, Q1, Q2, Q2_bar;
reg pb_out_reg;

clock_div u1(clk,slow_clk);
dff d0(slow_clk, pb_1, Q0);
dff d1(slow_clk, Q0, Q1);
dff d2(slow_clk, Q1, Q2);

assign Q2_bar = ~Q2;

assign pb_out = pb_out_reg;
always @(clk)
begin
    pb_out_reg = Q1 & Q2;
end

assign pb_out = pb_out_reg;

endmodule

// ----- Debounce Submodules ----- //
// Slow clock
module clock_div(
    input clk_100M,
    output slow_clk
    );

    reg [26:0] counter = 0;
    reg slow_clk_reg;
    always @(posedge(clk_100M))
    begin
        counter <= (counter >= 350)?0:counter+1;
        slow_clk_reg <= (counter < 175)?1'b0:1'b1;
    end
    
    assign slow_clk = slow_clk_reg;
endmodule

// D Flip-Flop
module dff(
    input clk,
    input d,
    output q
    );

    reg q_reg;
    always @(clk)
    begin
        q_reg <= d;
    end
    
    assign q = q_reg;
endmodule
