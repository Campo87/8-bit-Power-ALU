// -----------------------------------------------------------------------------
// FILE NAME : alu.v
// AUTHOR : JAMES STARKS
// -----------------------------------------------------------------------------
// DESCRIPTION
// The goal of this module is to decode the opcode and store result value from 
// the ALU module. Active high enable, active low reset, and clock enabled. If
// enable is low output is high Z. Reset sets accumulator register to 0.
// -----------------------------------------------------------------------------
module control(
    input  [20:0] opcode_in,
    input         en_in,
    input         clk_in,
    input         rst_in,
    output [7:0]  ans_out
);
    reg  [7:0]  accumulator;
    reg  [7:0]  rhs;
    wire [7:0]  results;

    // If enable pin is low, provide high Z on answer out wire
    assign ans_out = (en_in == 1'b1) ? accumulator : 8'bz;

    // Combinational logic mux for deciding to use accumulator or b imm value
    always @ (*) begin
        case(opcode_in[20])
            1'b0: rhs = opcode_in[19:12];
            1'b1: rhs = accumulator;
        endcase
    end 

    // Sequential logic for setting accumulator with synchronous reset
    always @ (posedge clk_in) begin
        if(rst_in == 1'b1)
            accumulator <= 8'b0;
        else
            // Mux prevents accumulator value from chaning if en is low
            accumulator <= (en_in == 1'b1) ? results : accumulator;
    end
    
    // ALU module instantiation 
    alu _alu(
        .a_in(opcode_in[11:4]),
        .b_in(rhs),
        .opcode_in(opcode_in[3:0]),
        .ans_out(results)
    );
    
endmodule
