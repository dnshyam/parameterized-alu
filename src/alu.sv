module alu #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [3:0]       op,

    input  logic             sat_en,
    input  logic             sat_signed,

    output logic [WIDTH-1:0] result,

    output logic zero,
    output logic carry,
    output logic overflow,
    output logic negative
);

logic sub;

logic [WIDTH-1:0] b_mod;
logic [WIDTH-1:0] add_result;
logic add_carry;
logic add_overflow;

logic [WIDTH-1:0] logic_result;
logic [WIDTH-1:0] shift_result;
logic [WIDTH-1:0] cmp_result;

logic [$clog2(WIDTH)-1:0] shamt;

logic [1:0] logic_op;
logic [1:0] shift_op;
logic [1:0] cmp_op;

assign shamt = b[$clog2(WIDTH)-1:0];

assign sub = (op == 4'b0001);

assign b_mod = b ^ {WIDTH{sub}};

cla_adder #(.WIDTH(WIDTH)) u_adder (
    .a(a),
    .b(b_mod),
    .cin(sub),
    .sum(add_result),
    .cout(add_carry)
);

assign add_overflow =
    (a[WIDTH-1] & b_mod[WIDTH-1] & ~add_result[WIDTH-1]) |
    (~a[WIDTH-1] & ~b_mod[WIDTH-1] & add_result[WIDTH-1]);

/* ---------------- LOGIC OPCODE DECODE ---------------- */

always @(*) begin
    case(op)
        4'b0010: logic_op = 2'b00; // AND
        4'b0011: logic_op = 2'b01; // OR
        4'b0100: logic_op = 2'b10; // XOR
        4'b0101: logic_op = 2'b11; // XNOR
        default: logic_op = 2'b00;
    endcase
end

/* ---------------- SHIFT OPCODE DECODE ---------------- */

always @(*) begin
    case(op)
        4'b0110: shift_op = 2'b00; // SLL
        4'b0111: shift_op = 2'b01; // SRL
        4'b1000: shift_op = 2'b10; // SRA
        default: shift_op = 2'b00;
    endcase
end

/* ---------------- COMPARE OPCODE DECODE ---------------- */

always @(*) begin
    case(op)
        4'b1001: cmp_op = 2'b00; // SLT
        4'b1010: cmp_op = 2'b01; // SLTU
        4'b1011: cmp_op = 2'b10; // MIN
        4'b1100: cmp_op = 2'b11; // MAX
        default: cmp_op = 2'b00;
    endcase
end

/* ---------------- LOGIC UNIT ---------------- */

logic_unit #(.WIDTH(WIDTH)) u_logic (
    .a(a),
    .b(b),
    .op(logic_op),
    .result(logic_result)
);

/* ---------------- SHIFT UNIT ---------------- */

shift_unit #(.WIDTH(WIDTH)) u_shift (
    .a(a),
    .shamt(shamt),
    .op(shift_op),
    .result(shift_result)
);

/* ---------------- COMPARE UNIT ---------------- */

compare_unit #(.WIDTH(WIDTH)) u_compare (
    .a(a),
    .b(b),
    .sub_result(add_result),
    .carry(add_carry),
    .overflow(add_overflow),
    .op(cmp_op),
    .result(cmp_result)
);

/* ---------------- RESULT MUX ---------------- */

logic [WIDTH-1:0] raw_result;

always @(*) begin

    case(op)

        4'b0000,
        4'b0001:
            raw_result = add_result;

        4'b0010,
        4'b0011,
        4'b0100,
        4'b0101:
            raw_result = logic_result;

        4'b0110,
        4'b0111,
        4'b1000:
            raw_result = shift_result;

        4'b1001,
        4'b1010,
        4'b1011,
        4'b1100:
            raw_result = cmp_result;

        default:
            raw_result = '0;

    endcase

end

/* ---------------- SATURATION LOGIC ---------------- */

logic [WIDTH-1:0] sat_result;

always @(*) begin

    sat_result = raw_result;

    if (sat_en && add_overflow) begin

        if (sat_signed) begin

            if (add_result[WIDTH-1])
                sat_result = {1'b1, {(WIDTH-1){1'b0}}};
            else
                sat_result = {1'b0, {(WIDTH-1){1'b1}}};

        end
        else begin
            sat_result = {WIDTH{1'b1}};
        end

    end

end

assign result = sat_result;

/* ---------------- FLAGS ---------------- */

flag_unit #(.WIDTH(WIDTH)) u_flags (
    .result(result),
    .carry_in(add_carry),
    .overflow_in(add_overflow),
    .zero(zero),
    .carry(carry),
    .overflow(overflow),
    .negative(negative)
);

endmodule