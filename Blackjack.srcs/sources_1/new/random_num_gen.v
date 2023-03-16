`timescale 1ns / 1ps


module random_num_gen(
    input clock,
    input reset,
    input score,
    output [4:0] rnd 
    );
    
    localparam len = 5;
    
    reg [len-1:0] random = 5'hF;
    reg [len-1:0] random_next, random_done;
    reg [3:0] count = 0;
    reg [3:0] count_next; //to keep track of the shifts
    
    wire feedback = random[len-1] ^ random[2] ^ random[0]; 


    always @ (*)
    begin
        random_next = random; //default state stays the same
        count_next = count;
      
        random_next = {random[len-2:0], feedback}; //shift left the xor'd every posedge clock
        count_next = count + 1;
    
        if (count == len)
        begin
            count = 0;
            random_done = random; //assign the random number to output after 13 shifts
            if (score)
            begin
                if (random_done > 21)
                begin
                    random_done = random_done / 2;
                end
            end
            else
            begin
                if (random_done > 10)
                begin
                    random_done = random_done / 4;
                end
            end 
        end
    end

    assign rnd = random_done;

endmodule
