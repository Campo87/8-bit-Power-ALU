///////////////////////////////////////////////////////////////////////////////
// This module contains the instructions for the Power ALU and decodes them. Decoded instructions 
// are sent out on ouput registers that the ALU actively looks at.
///////////////////////////////////////////////////////////////////////////////
module control(a, b, op, alu_en, acc, alu_done, rst, clk);
    // Output values to be operated on
    output reg [7:0] a, b;
    // Op code for the ALU
    output reg [3:0] op;
    // Alu_en lets the ALU know to begin
    // Acc lets the ALU know if it should use the accumlator
    output reg alu_en, acc;

    // Alu_done notifies the control module that the ALU is done
    // Rst puts the control module in it's default state
    // Clk controls when states transistion
    input alu_done, rst, clk;

    // Used for addressing instruction memory (ROM)
    reg [4:0] pc;
    // Stores instructions
    reg [20:0] rom [31:0];

    // Holds current state of the control module
    reg [1:0] curr_state;
    // Map states to a more read-able format 
    parameter decode = 2'b00;
    parameter alu_done_check = 2'b01;
    parameter brick = 2'b10;

    // Initialize pc to address 0 and fill ROM with instructions
    // Instructions format 
    // [20]     - Acc bit
    // [19:12]  - B Immediate Value
    // [11:4]   - A Immediate Value
    // [3:0]    - Op code
    //
    initial begin
        pc = 0;
        rom[0] =  21'b000011101001100000000;
        rom[1] =  21'b000011101001100000001;
        rom[2] =  21'b000011101001100000010;
        rom[3] =  21'b000011101001100000011;
        rom[4] =  21'b000011101001100000100;
        rom[5] =  21'b000011101001100000101;
        rom[6] =  21'b000011101001100000110;
        rom[7] =  21'b000011101001100000111;
        rom[8] =  21'b000011101001100001000;
        rom[9] =  21'b000011101001100001001;
        rom[10] = 21'b000011101001100001010;
        rom[11] = 21'b000011101001100001011;
        rom[12] = 21'b000011101001100001100;
        rom[13] = 21'b000011101001100001101;
        rom[14] = 21'b000011101001100001110;
        rom[15] = 21'b000011101001100001111;
        rom[16] = 21'b100011101001100000000;
        rom[17] = 21'b100011101001100000001;
        rom[18] = 21'b100011101001100000010;
        rom[19] = 21'b100011101001100000011;
        rom[20] = 21'b100011101001100000100;
        rom[21] = 21'b100011101001100000101;
        rom[22] = 21'b100011101001100000110;
        rom[23] = 21'b100011101001100000111;
        rom[24] = 21'b100011101001100001000;
        rom[25] = 21'b100011101001100001001;
        rom[26] = 21'b100011101001100001010;
        rom[27] = 21'b100011101001100001011;
        rom[28] = 21'b100011101001100001100;
        rom[29] = 21'b100011101001100001101;
        rom[30] = 21'b100011101001100001110;
        rom[31] = 21'b100011101001100001111;
    end

    // Enter on posedge of clk or rst
    always@(posedge clk, posedge rst) begin
        // Reset control module w/ active high rst 
        if (rst) begin
            curr_state = decode;
            pc = 0;
        end else begin
            case(curr_state)
                // Parse out instruction for the ALU
                decode: begin 
                    op = rom[pc][3:0];
                    a = rom[pc][11:4];
                    b = rom[pc][19:12];
                    acc = rom[pc][20];
                    // Notify ALU to start
                    alu_en = 1;
                    
                    curr_state = alu_done_check;
                end
                // Wait for ALU to notify it's done
                alu_done_check: begin
                    alu_en = 0;
                    // ALU finished
                    if(alu_done) begin
                        // Increment program counter
                        pc = pc + 1;

                        // Start over!
                        curr_state = decode;
                    end else begin
                        curr_state = curr_state;
                    end
                end
            endcase
        end
    end
endmodule
