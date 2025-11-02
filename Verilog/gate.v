// fluid_structural.v — Structural model for fluid dispenser with per-user visit tracking
`timescale 1ns/1ps

// ----------------------------
// D Flip-Flop (used in counter)
// ----------------------------
module dff (input d, input clk, input reset, output reg q);
    always @(posedge clk or posedge reset)
        if (reset) q <= 0;
        else q <= d;
endmodule

// ----------------------------
// 4-bit Binary Counter (enabled)
// ----------------------------
module counter4 (input clk, input reset, input enable, output [3:0] q);
    wire [3:0] d;
    wire t1, t2, t3;

    xor (d[0], q[0], enable);
    and (t1, q[0], enable);
    xor (d[1], q[1], t1);
    and (t2, q[0], q[1], enable);
    xor (d[2], q[2], t2);
    and (t3, q[0], q[1], q[2], enable);
    xor (d[3], q[3], t3);

    dff ff0 (d[0], clk, reset, q[0]);
    dff ff1 (d[1], clk, reset, q[1]);
    dff ff2 (d[2], clk, reset, q[2]);
    dff ff3 (d[3], clk, reset, q[3]);
endmodule

// ----------------------------
// Visit Tracker — Structural (Per-user)
// ----------------------------
module visit_tracker (
    input clk, reset,
    input [3:0] user_id,
    output [7:0] visits
);
    wire [3:0] visit[0:15];
    wire enable[0:15];

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : COUNTERS
            assign enable[i] = (user_id == i);  // Only selected user's counter increments
            counter4 c (.clk(clk), .reset(reset), .enable(enable[i]), .q(visit[i]));
        end
    endgenerate

    reg [7:0] out_visit;
    always @(*) begin
        case (user_id)
            4'd0: out_visit = {4'b0000, visit[0]};
            4'd1: out_visit = {4'b0000, visit[1]};
            4'd2: out_visit = {4'b0000, visit[2]};
            4'd3: out_visit = {4'b0000, visit[3]};
            4'd4: out_visit = {4'b0000, visit[4]};
            4'd5: out_visit = {4'b0000, visit[5]};
            4'd6: out_visit = {4'b0000, visit[6]};
            4'd7: out_visit = {4'b0000, visit[7]};
            4'd8: out_visit = {4'b0000, visit[8]};
            4'd9: out_visit = {4'b0000, visit[9]};
            4'd10: out_visit = {4'b0000, visit[10]};
            4'd11: out_visit = {4'b0000, visit[11]};
            4'd12: out_visit = {4'b0000, visit[12]};
            4'd13: out_visit = {4'b0000, visit[13]};
            4'd14: out_visit = {4'b0000, visit[14]};
            4'd15: out_visit = {4'b0000, visit[15]};
        endcase
    end

    assign visits = out_visit;
endmodule

// ------------------------------------
// Price Calculator (with slab pricing)
// ------------------------------------
module price_calculator (
    input [1:0] fluid_type,
    input [7:0] volume_l,
    output reg [15:0] price
);
    reg [15:0] first_part, second_part;

    always @(*) begin
        if (volume_l <= 1) begin
            first_part = volume_l;
            second_part = 0;
        end else begin
            first_part = 1;
            second_part = volume_l - 1;
        end

        case (fluid_type)
            2'b00: price = (first_part * 20) + (second_part * 10); // Water
            2'b01: price = (first_part * 50) + (second_part * 30); // Juice
            2'b10: price = (first_part * 40) + (second_part * 20); // Chemical
            default: price = 0;
        endcase
    end
endmodule

// ------------------------------------
// Discount Calculator
// ------------------------------------
module discount_calculator (
    input [7:0] visits,
    input [15:0] price,
    output reg [7:0] discount_percent,
    output [15:0] final_price
);
    always @(*) begin
        if (visits <= 2)
            discount_percent = 0;
        else if (visits <= 4)
            discount_percent = 10;
        else
            discount_percent = 20;
    end

    assign final_price = price - ((price * discount_percent) / 100);
endmodule

// ------------------------------------
// Stock Manager (Structural)
// ------------------------------------
module stock_manager (
    input [1:0] fluid_type,
    input [7:0] volume_l,
    output reg [15:0] remaining_qty,
    output reg [7:0] message
);
    reg [15:0] water, juice, chemical;

    initial begin
        water = 100;
        juice = 80;
        chemical = 60;
    end

    always @(*) begin
        message = 0;
        case (fluid_type)
            2'b00: begin
                if (volume_l > water) begin
                    message = 1;
                    remaining_qty = water;
                end else remaining_qty = water - volume_l;
            end
            2'b01: begin
                if (volume_l > juice) begin
                    message = 1;
                    remaining_qty = juice;
                end else remaining_qty = juice - volume_l;
            end
            2'b10: begin
                if (volume_l > chemical) begin
                    message = 1;
                    remaining_qty = chemical;
                end else remaining_qty = chemical - volume_l;
            end
            default: message = 1;
        endcase
    end
endmodule

// ------------------------------------
// Top-Level: fluid_dispenser (Structural)
// ------------------------------------
module fluid_dispenser (
    input [1:0] fluid_type,
    input [7:0] volume_l,
    input [7:0] visits,
    output [15:0] original_price,
    output [15:0] final_price,
    output [7:0] discount_percent,
    output [15:0] remaining_qty,
    output [7:0] message
);
    price_calculator p1 (.fluid_type(fluid_type), .volume_l(volume_l), .price(original_price));
    discount_calculator d1 (.visits(visits), .price(original_price),
                            .discount_percent(discount_percent), .final_price(final_price));
    stock_manager s1 (.fluid_type(fluid_type), .volume_l(volume_l),
                      .remaining_qty(remaining_qty), .message(message));
endmodule
