module tb_shift_unit;

parameter WIDTH = 32;

logic [WIDTH-1:0] a;
logic [$clog2(WIDTH)-1:0] shamt;
logic [1:0] op;

logic [WIDTH-1:0] result;

shift_unit #(.WIDTH(WIDTH)) dut (
    .a(a),
    .shamt(shamt),
    .op(op),
    .result(result)
);

initial begin

    $dumpfile("shift_wave.vcd");
    $dumpvars(0, tb_shift_unit);

    a = 32'h00000010;
    shamt = 2;

    op = 2'b00; #10; // SLL
    op = 2'b01; #10; // SRL

    a = 32'h80000000;
    shamt = 1;
    op = 2'b10; #10; // SRA

    $finish;

end

endmodule