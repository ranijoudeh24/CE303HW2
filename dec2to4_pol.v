`timescale 1ns/1ps
// dec2to4_pol.v  
module dec2to4_pol (
    input  A2,       
    input  A1, A0,  
    output reg [3:0] D   
);
    reg [3:0] onehot;   
    reg [3:0] vec_img;  

    always @(*) begin
        case ({A1,A0})
            2'b00: onehot = 4'b0001;
            2'b01: onehot = 4'b0010;
            2'b10: onehot = 4'b0100;
            2'b11: onehot = 4'b1000;
        endcase
        
        vec_img = { onehot[3], onehot[2], onehot[0], onehot[1] };
        D = (A2 == 1'b1) ? vec_img : ~vec_img;
    end
endmodule
