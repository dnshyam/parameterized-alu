module compare_unit #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,

    input  logic [WIDTH-1:0] sub_result,
    input  logic             carry,
    input  logic             overflow,

    input  logic [1:0] op,

    output logic [WIDTH-1:0] result
);

logic signed_less;
logic unsigned_less;

assign signed_less   = ($signed(a) < $signed(b));
assign unsigned_less = (a < b);

always @(*) begin

    case(op)

        2'b00: result = signed_less   ? 32'd1 : 32'd0; // SLT

        2'b01: result = unsigned_less ? 32'd1 : 32'd0; // SLTU

        2'b10: result = signed_less ? a : b; // MIN

        2'b11: result = signed_less ? b : a; // MAX

        default: result = '0;

    endcase

end

endmodule