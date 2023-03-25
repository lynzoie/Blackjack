`timescale 1ns / 1ps


module random_num_gen
    #(parameter START_VAL=5) 
    (
    input clock,
    input [4:0] val_limit,
    output [4:0] rnd 
    );
    
    localparam len = 5;
    reg [len-1:0] random = START_VAL;    // default 5'hF
    reg [len-1:0] random_next, random_done;
    reg [3:0] count = 0;
    reg [3:0] count_next; //to keep track of the shifts

    wire feedback = random[len-1] ^ random[2] ^ random[0]; 

    always @ (posedge clock)
    begin    
        random <= random_next;
        count <= count_next;
    end

    always @ (*)
    begin
//        random_next = random; //default state stays the same
//        count_next = count;
      
        random_next = {random[len-2:0], feedback}; //shift left the xor'd every posedge clock
        count_next = count + 1;
    
        if (count == len)
        begin
//            count = 0;
            count_next = 0;
            random_done = random; //assign the random number to output after len shifts
            if (random_done > val_limit)
            begin
                random_done = random_done / (val_limit/2);
            end
        end
    end

    assign rnd = random_done;

endmodule
