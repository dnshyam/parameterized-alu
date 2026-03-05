module flag_unit #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH-1:0] result,
    input  logic             carry_in,
    input  logic             overflow_in,

    output logic zero,
    output logic carry,
    output logic overflow,
    output logic negative
);

assign zero     = (result == '0);
assign negative = result[WIDTH-1];

assign carry    = carry_in;
assign overflow = overflow_in;

endmodule