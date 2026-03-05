module cla_adder #(
    parameter int WIDTH = 32,
    parameter int BLOCK = 4
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic             cin,

    output logic [WIDTH-1:0] sum,
    output logic             cout
);

localparam int NUM_BLOCKS = WIDTH / BLOCK;

logic [NUM_BLOCKS:0] carry;

assign carry[0] = cin;

genvar i;

generate
    for (i = 0; i < NUM_BLOCKS; i++) begin : CLA_BLOCKS

        cla_block u_cla_block (
            .a   (a[i*BLOCK +: BLOCK]),
            .b   (b[i*BLOCK +: BLOCK]),
            .cin (carry[i]),

            .sum (sum[i*BLOCK +: BLOCK]),
            .cout(carry[i+1])
        );

    end
endgenerate

assign cout = carry[NUM_BLOCKS];

endmodule