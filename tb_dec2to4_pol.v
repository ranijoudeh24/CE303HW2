// tb_dec2to4_pol.v (Verilog-2001, fixed concat indexing on function return)
`timescale 1ns/1ps

module tb_dec2to4_pol;
    reg  A2, A1, A0;
    wire [3:0] D;
    reg  [3:0] expected;
    reg  [3:0] tmp;  // hold onehot() return for bit selects
    integer i;

    // DUT
    dec2to4_pol dut(.A2(A2), .A1(A1), .A0(A0), .D(D));

    // Helper: one-hot for {A1,A0}
    function [3:0] onehot;
        input [1:0] sel;
        begin
            case (sel)
                2'b00: onehot = 4'b0001; // D0
                2'b01: onehot = 4'b0010; // D1
                2'b10: onehot = 4'b0100; // D2
                2'b11: onehot = 4'b1000; // D3
            endcase
        end
    endfunction

    initial begin
        // VCD for waveform viewing
        $dumpfile("tb_dec2to4_pol.vcd");
        $dumpvars(0, tb_dec2to4_pol);

        $display("A2 A1 A0 | D3 D2 D1 D0 | PASS");
        for (i=0; i<8; i=i+1) begin
            {A2,A1,A0} = i[2:0];
            #1;
            tmp = onehot({A1,A0});
            // Build expected in the same figure order {D3,D2,D1,D0}
            expected = { tmp[3], tmp[2], tmp[0], tmp[1] };
            expected = (A2==1'b1) ? expected : ~expected;

            $display("%0b  %0b  %0b |  %0b  %0b  %0b  %0b | %s",
                     A2,A1,A0, D[3],D[2],D[1],D[0], (D===expected) ? "OK" : "FAIL");
            if (D !== expected) begin
                $error("Mismatch for inputs A2A1A0=%b: got %b expected %b", {A2,A1,A0}, D, expected);
            end
        end
        $finish;
    end
endmodule
