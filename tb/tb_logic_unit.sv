module tb_logic_unit;

parameter WIDTH = 32;

logic [WIDTH-1:0] a;
logic [WIDTH-1:0] b;
logic [1:0] op;

logic [WIDTH-1:0] result;

logic_unit #(.WIDTH(WIDTH)) dut (
    .a(a),
    .b(b),
    .op(op),
    .result(result)
);

initial begin

    $dumpfile("logic_wave.vcd");
    $dumpvars(0, tb_logic_unit);

    a = 32'hF0F0F0F0;
    b = 32'h0F0F0F0F;

    op = 2'b00; #10;
    op = 2'b01; #10;
    op = 2'b10; #10;
    op = 2'b11; #10;

    $finish;
end

endmodule