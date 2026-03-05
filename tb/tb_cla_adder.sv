module tb_cla_adder;

parameter WIDTH = 32;

logic [WIDTH-1:0] a;
logic [WIDTH-1:0] b;
logic cin;

logic [WIDTH-1:0] sum;
logic cout;

cla_adder #(.WIDTH(WIDTH)) dut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin

    $dumpfile("wave.vcd");
    $dumpvars(0, tb_cla_adder);

    a = 0;
    b = 0;
    cin = 0;

    #10;

    a = 32'h0000000F;
    b = 32'h00000000;

    #10;

    a = 32'hFFFFFFFF;
    b = 32'h00000001;

    #10;

    $finish;
end

endmodule