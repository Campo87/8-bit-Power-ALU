// -----------------------------------------------------------------------------
// FILE NAME : powerALU_tb.v
// AUTHOR : JAMES STARKS
// -----------------------------------------------------------------------------
// DESCRIPTION
// Testbench for testing control.v and alu.v logic circuit.
// -----------------------------------------------------------------------------
module powerALU_tb();
    reg  [20:0] opcode;
    reg         clk;
    reg         rst;
    reg         en;
    wire [7:0]  ans;

    integer i, j;

    control _dut(
        .opcode_in(opcode),
        .en_in(en),
        .clk_in(clk),
        .rst_in(rst),
        .ans_out(ans)
    );

    initial begin
        opcode = 21'b0;
        clk = 0;
        rst = 0;
    end

    initial forever #2 clk = ~clk;

    initial begin
        #2 rst = 1;
        #2 rst = 0; opcode = 21'b0;
        
        $display("==========================");
        for(j = 0; j <= 1; j = j + 1) begin
            $display("Accumulator bit: %b", j[0]);
            for(i = 0; i <= 15; i = i + 1) begin
                #4 en = 1'b1; opcode = {j[0], 8'd25, 8'd50, i[3:0]};
                $display("Opcode: %h  ACC: %b  A: %d\tB: %d\tAnswer: %d", opcode[3:0], opcode[20], opcode[11:4], opcode[19:12], ans);
            end
            $display("==========================");
        end
        #4 en = 1'b0;
        #2 $finish();
    end

endmodule
