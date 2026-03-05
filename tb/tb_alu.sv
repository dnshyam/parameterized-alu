module tb_alu;

parameter WIDTH = 32;

logic [WIDTH-1:0] a;
logic [WIDTH-1:0] b;
logic [3:0] op;

logic sat_en;
logic sat_signed;

logic [WIDTH-1:0] result;

logic zero;
logic carry;
logic overflow;
logic negative;

alu #(.WIDTH(WIDTH)) dut (
    .a(a),
    .b(b),
    .op(op),
    .sat_en(sat_en),
    .sat_signed(sat_signed),
    .result(result),
    .zero(zero),
    .carry(carry),
    .overflow(overflow),
    .negative(negative)
);

logic [WIDTH-1:0] expected;

task check;

    if (result !== expected) begin

        $display("ERROR op=%b a=%h b=%h", op, a, b);
        $display("expected=%h got=%h", expected, result);

        $fatal;

    end
    else begin

        $display("PASS op=%b result=%h", op, result);

    end

endtask

initial begin

    $dumpfile("alu_wave.vcd");
    $dumpvars(0, tb_alu);

    sat_en = 0;
    sat_signed = 0;

    // ADD
    a = 10;
    b = 20;
    op = 4'b0000;
    #10;
    expected = a + b;
    check();

    // SUB
    a = 50;
    b = 10;
    op = 4'b0001;
    #10;
    expected = a - b;
    check();

    // AND
    a = 32'hF0F0F0F0;
    b = 32'h0F0F0F0F;
    op = 4'b0010;
    #10;
    expected = a & b;
    check();

    // OR
    op = 4'b0011;
    #10;
    expected = a | b;
    check();

    // XOR
    op = 4'b0100;
    #10;
    expected = a ^ b;
    check();

    // XNOR
    op = 4'b0101;
    #10;
    expected = ~(a ^ b);
    check();

    // SLL
    a = 32'h00000010;
    b = 2;
    op = 4'b0110;
    #10;
    expected = a << 2;
    check();

    // SRL
    op = 4'b0111;
    #10;
    expected = a >> 2;
    check();

    // SRA
    a = 32'h80000000;
    b = 1;
    op = 4'b1000;
    #10;
    expected = $signed(a) >>> 1;
    check();

    // SLT
    a = 5;
    b = 10;
    op = 4'b1001;
    #10;
    expected = ( $signed(a) < $signed(b) ) ? 1 : 0;
    check();

    // SLTU
    op = 4'b1010;
    #10;
    expected = ( a < b ) ? 1 : 0;
    check();

    // MIN
    op = 4'b1011;
    #10;
    expected = ( $signed(a) < $signed(b) ) ? a : b;
    check();

    // MAX
    op = 4'b1100;
    #10;
    expected = ( $signed(a) < $signed(b) ) ? b : a;
    check();

    $display("ALL TESTS PASSED");

    $finish;

end

endmodule