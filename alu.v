///////////////////////////////////////////////////////////////////////////////
// ALU takes in two values and an Opcode and puts the results out for observation 
// along with the accumulator. 
///////////////////////////////////////////////////////////////////////////////
module alu(results, accumulator, alu_done, a, b, op, clk, en, acc, rst);
    // Results stores the calculated values
    // After writing this program I realized accumlator is redundent...Ignore it.
    output reg [7:0] results, accumulator;
    // Notify the Control module calculations are done
    output reg alu_done;

    // Immediate values from Control module
    input [7:0] a, b;
    // Op code from Control module
    input [3:0] op;
    
    // Clk controls when states transistion
    // Enable lets the ALU know when to start
    // Acc will let the ALU know if it needs to use the accumulator value
    // Rst puts the ALU module in it's default state
    input clk, en, acc, rst;

    // Holds incoming immediate values for A and B
    reg [7:0] temp_a, temp_b;

    // Holds current state of the ALU module
    reg [2:0] curr_state;
    // Map states to a more read-able format 
    parameter wait_en = 3'b000;
    parameter load_a = 3'b001;
    parameter load_b = 3'b010;
    parameter go = 3'b011;
    parameter done = 3'b100;

    // Map Opcodes to a more read-able format 
    parameter transfer_a  = 4'b0000; // Set accumulator to A
    parameter increment_a = 4'b0001; // Set accumulator to Add 1 to A
    parameter add         = 4'b0010; // Set accumulator to Add A to B
    parameter sub         = 4'b0011; // Set accumulator to Sub A from B
    parameter decrement_a = 4'b0100; // Set accumulator to Sub 1 from A
    parameter ones        = 4'b0101; // Set accumulator to Inverse all the bits in A
    parameter _and        = 4'b0110; // Set accumulator to Bitwise A and B
    parameter _nand       = 4'b0111; // Set accumulator to Bitwise A nand B
    parameter _or         = 4'b1000; // Set accumulator to Bitwise A or B
    parameter _nor        = 4'b1001; // Set accumulator to Bitwise A nor B
    parameter _xor        = 4'b1010; // Set accumulator to Bitwise A xor B
    parameter _xnor       = 4'b1011; // Set accumulator to Bitwise A xnor B
    parameter gt          = 4'b1100; // Set accumulator to the the larger input value
    parameter lt          = 4'b1101; // Set accumulator to the smaller input value
    parameter eq          = 4'b1110; // Set accumulator to A if A equals B, else set to HiZ
    parameter nop         = 4'b1111; // Do nothing

    // Zero out registers and set ALU to wait_en state
    initial begin
        results = 8'b0; accumulator = 8'b0;
        temp_a  = 8'b0; temp_b      = 8'b0;
        curr_state = wait_en;

    end

    // Enter on posedge of clk or rst
    always@(posedge clk, posedge rst) begin
        // Reset ALU w/ active high rst
        if(rst) begin
            curr_state = wait_en; alu_done = 0;
            temp_a = 8'bz; temp_b = 8'bz; results = 8'bz;
        end else begin
            case(curr_state) 
                // Wait for control to signal start
                wait_en: begin
                    curr_state = load_a;
                    alu_done = 0;
                end
                // Store input A into temp_a register
                load_a: begin
                    temp_a = a;
                    curr_state = load_b;
                end
                // Store input B or accumulator into temp_b register
                load_b: begin
                    // If instructions says to use accumulator, set temp_b equal to accumulator
                    // It uses the last results
                    if (acc)
                        temp_b = accumulator;
                    // Don't use accumulator
                    else
                        temp_b = b;
                    
                    curr_state = go;
                end
                // Start arithmetic calculations
                go: begin
                    case(op)
                        // Lock above at parameter comments to know what's going on ehre
                        transfer_a:  accumulator = temp_a;
                        increment_a: accumulator = temp_a + 1;
                        add:         accumulator = temp_a + temp_b;
                        sub:         accumulator = temp_a - temp_b;
                        decrement_a: accumulator = temp_a - 1;
                        ones:        accumulator = ~temp_a;
                        _and:        accumulator = temp_a & temp_b;
                        _nand:       accumulator = ~(temp_a & temp_b);
                        _or:         accumulator = temp_a | temp_b;
                        _nor:        accumulator = ~(temp_a | temp_b);
                        _xor:        accumulator = temp_a ^ temp_b;
                        _xnor:       accumulator = temp_a ~^ temp_b;
                        gt: begin
                            if (temp_a > temp_b) begin
                                accumulator = temp_a;
                            end else begin 
                                accumulator = temp_b;
                            end
                        end
                        lt: begin
                            if (temp_a < temp_b) begin
                                accumulator = temp_a;
                            end else begin 
                                accumulator = temp_b;
                            end
                        end
                        eq: begin
                            if (temp_a == temp_b) begin
                                accumulator = a;
                            end else begin
                                accumulator = 8'bz;
                            end
                        end
                    endcase
                    curr_state = done;
                end
                // Let control know the ALU is done, so it can begin processing next instruction
                done: begin
                    alu_done   = 1;
                    results    = accumulator;
                    curr_state = wait_en;
                end
            endcase
        end
    end
endmodule
