// -----------------------------------------------------------------------------
// FILE NAME : alu.v
// AUTHOR : JAMES STARKS
// -----------------------------------------------------------------------------
// DESCRIPTION
// This ALU supports up to 16 instructions and uses combinational logic to 
// decode and compute instructions. 
// -----------------------------------------------------------------------------
module alu(
    input   [7:0]   a_in,
    input   [7:0]   b_in,
    input   [3:0]   opcode_in,
    output  [7:0]   ans_out
);
    reg  [7:0] ans;
    assign ans_out = ans;

    // Combinational ALU logic
    always @ (*) begin
        case(opcode_in)
            4'h0: ans =   8'bz;                         // NOP
            4'h1: ans =   a_in;                         // store a
            4'h2: ans =   a_in + 8'd1;                  // increment a
            4'h3: ans =   a_in + b_in;                  // a + b
            4'h4: ans =   a_in - b_in;                  // a - b
            4'h5: ans =   a_in - 8'd1;                  // decrement a
            4'h6: ans =  ~a_in;                         // not a
            4'h7: ans =   a_in &  b_in;                 // a and b
            4'h8: ans = ~(a_in &  b_in);                // a nand b
            4'h9: ans =   a_in |  b_in;                 // a or b
            4'ha: ans = ~(a_in |  b_in);                // a nor b
            4'hb: ans =   a_in ^  b_in;                 // a xor b
            4'hc: ans =   a_in ~^ b_in;                 // a xnor b
            4'hd: ans =  (a_in >  b_in) ? a_in : b_in;  // a greater b 
            4'he: ans =  (a_in <  b_in) ? a_in : b_in;  // a lesser b
            4'hf: ans =  (a_in == b_in) ? a_in : 8'bz;  // a equals b
            default: ans = 8'bz;                        // 
        endcase        
    end

endmodule
