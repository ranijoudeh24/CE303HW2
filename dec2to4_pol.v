// dec2to4_pol.v  (Verilog-2001, fixed ANSI port decl)
module dec2to4_pol (
    input  A2,       // POL: 1=one-hot, 0=one-cold
    input  A1, A0,   // select
    output reg [3:0] D   // declare as reg here (ANSI), no redeclare inside
);
    reg [3:0] onehot;   // [D0,D1,D2,D3] in index order
    reg [3:0] vec_img;  // mapped to image order {D3,D2,D1,D0}

    always @(*) begin
        // one-hot by {A1,A0}
        case ({A1,A0})
            2'b00: onehot = 4'b0001; // D0
            2'b01: onehot = 4'b0010; // D1
            2'b10: onehot = 4'b0100; // D2
            2'b11: onehot = 4'b1000; // D3
        endcase
        // Map to figure col order: {D3,D2,D1,D0} with D1<->D0 swapped
        vec_img = { onehot[3], onehot[2], onehot[0], onehot[1] };
        // Polarity control
        D = (A2 == 1'b1) ? vec_img : ~vec_img;
    end
endmodule
