/*
    This module is the test bench for my Power ALU. All modules are reset, then clk is set to run. 
    All instructions for the ALU are contained in the control module.
*/
module powerALU_tb();
    reg clk, rst, c_en;

    wire [7:0] a, b, results, accumulator;
    wire [3:0] op;

    wire alu_en, acc, alu_done;

    control _control(a, b, op, alu_en, acc, alu_done, rst, clk);
    alu _alu(results, accumulator, alu_done, a, b, op, clk, alu_en, acc, rst);

    initial
        forever #2 clk = ~clk;
    
    initial begin
        $monitor("\nOp:%b\tA:%b\tB:%b\tACC:%b\tAccumulator:%b\nResults:%b", op, a, b, acc, accumulator, results);
        rst = 1; clk = 0; c_en = 0; // rst
        #10 rst = 0; c_en = 1; // begin!
    end

endmodule
