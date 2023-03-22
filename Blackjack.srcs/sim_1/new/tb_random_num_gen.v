`timescale 1ns / 1ps


module tb_random_num_gen;
    // Module inputs
    reg clock = 1'b0;
    reg [4:0] val_limit;
    
    // Module outputs
    wire [4:0] rnd; 

    localparam period = 0.5;
    random_num_gen #(.START_VAL(22)) UUT(.clock(clock),
        .val_limit(val_limit),
        .rnd(rnd)
        );
    
    
    // Create fake clock
    always
    begin
        clock = 1'b0;
        #period;
        clock = 1'b1;
        #period;
    end
    
    // Changed val_limit
    always
    begin
        val_limit = 5'd21;
        #200;
        val_limit = 5'd10;
        #200;
    end
        
endmodule
