# 8-bit-Power-ALU
The goal of this project was to design an 8-bit ALU which implements 16 operations.

### Instruction Structure

|  ACC  |      A(LHS)      |      B(RHS)      | OPCODE |
| ------| ----------- | ----------- | ------ | 
| 1-bit |    8-bit    |    8-bit    | 8-bit  |


    ACC: Accumulator select bit 
        High: Use previous result stored in the accumulator register for right-hand-side of operand.
        Low: Use B immediate value for right-hand-side of operand.
    A: Immediate value used for all left-hand-side of operand (signed).
    B: Immediate value used for right-hand-side of operand depending on acc bit (signed).
    OPCODE: Operand select.
### Opcode Overview
| OPCODE | Instruction  |
|--------|--------------|
|0x0     |    NOP       |
|0x1     |Load A into accumulator|
|0x2     |    A++       |
|0x3     |    A + B     |
|0x4     |    A - B     |
|0x5     |    A--       |
|0x6     |    !A        |
|0x7     |    A & B     |
|0x8     |    ~(A & B)  |
|0x9     |    A \| B    |
|0xA     |    ~(A \| B) |
|0xB     |    (A ^ B)   |
|0xC     |    A ~^ B    |
|0xD     |    A > B     |
|0xE     |    A < B     |
|0xF     |    A == B    |
