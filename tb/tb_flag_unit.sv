module tb_flag_unit;

parameter WIDTH = 32;

logic [WIDTH-1:0] result;
logic carry_in;
logic overflow_in;

logic zero;
logic carry;
logic overflow;
logic negative;

flag_unit #(.WIDTH(WIDTH)) dut (
    .result(result),
    .carry_in(carry_in),
    .overflow_in(overflow_in),
    .zero(zero),
    .carry(carry),
    .overflow(overflow),
    .negative(negative)
);

initial begin

    $dumpfile("flag_wave.vcd");
    $dumpvars(0, tb_flag_unit);

    result = 0;
    carry_in = 0;
    overflow_in = 0;
    #10;

    result = 32'hFFFFFFFF;
    #10;

    result = 1;
    carry_in = 1;
    #10;

    $finish;

end

endmodule