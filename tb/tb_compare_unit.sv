module tb_compare_unit;

parameter WIDTH = 32;

logic [WIDTH-1:0] a;
logic [WIDTH-1:0] b;

logic [WIDTH-1:0] sub_result;
logic carry;
logic overflow;

logic [1:0] op;

logic [WIDTH-1:0] result;

compare_unit #(.WIDTH(WIDTH)) dut (
    .a(a),
    .b(b),
    .sub_result(sub_result),
    .carry(carry),
    .overflow(overflow),
    .op(op),
    .result(result)
);

initial begin

    $dumpfile("compare_wave.vcd");
    $dumpvars(0, tb_compare_unit);

    a = 10;
    b = 20;

    sub_result = a - b;
    carry = 0;
    overflow = 0;

    op = 2'b00; #10; // SLT

    op = 2'b10; #10; // MIN

    op = 2'b11; #10; // MAX

    $finish;

end

endmodule