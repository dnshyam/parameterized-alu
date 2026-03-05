module logic_unit #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [1:0]       op,

    output logic [WIDTH-1:0] result
);

logic [WIDTH-1:0] and_r;
logic [WIDTH-1:0] or_r;
logic [WIDTH-1:0] xor_r;
logic [WIDTH-1:0] xnor_r;

assign and_r  = a & b;
assign or_r   = a | b;
assign xor_r  = a ^ b;
assign xnor_r = ~(a ^ b);

always_comb begin
    case (op)
        2'b00: result = and_r;
        2'b01: result = or_r;
        2'b10: result = xor_r;
        2'b11: result = xnor_r;
        default: result = '0;
    endcase
end

endmodule