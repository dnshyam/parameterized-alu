module shift_unit #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH-1:0] a,
    input  logic [$clog2(WIDTH)-1:0] shamt,
    input  logic [1:0] op,

    output logic [WIDTH-1:0] result
);

always_comb begin
    case (op)

        2'b00: result = a << shamt;   // SLL
        2'b01: result = a >> shamt;   // SRL
        2'b10: result = $signed(a) >>> shamt; // SRA

        default: result = '0;

    endcase
end

endmodule