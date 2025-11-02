`timescale 1ns/1ps

// ----------------------------------------------------
// D Flip-Flop (still sequential, used for visit counters)
// ----------------------------------------------------
module dff (
    input d,
    input clk,
    input reset,
    output reg q
);
    always @(posedge clk or posedge reset)
        if (reset) q <= 0;
        else q <= d;
endmodule

// ----------------------------------------------------
// 4-bit Counter (Dataflow style)
// ----------------------------------------------------
module counter4 (
    input clk,
    input reset,
    input enable,
    output [3:0] q
);
    wire [3:0] next_q;
    wire t1, t2, t3;

    assign next_q[0] = q[0] ^ enable;
    assign t1 = q[0] & enable;
    assign next_q[1] = q[1] ^ t1;

    assign t2 = q[0] & q[1] & enable;
    assign next_q[2] = q[2] ^ t2;

    assign t3 = q[0] & q[1] & q[2] & enable;
    assign next_q[3] = q[3] ^ t3;

    dff ff0 (.d(next_q[0]), .clk(clk), .reset(reset), .q(q[0]));
    dff ff1 (.d(next_q[1]), .clk(clk), .reset(reset), .q(q[1]));
    dff ff2 (.d(next_q[2]), .clk(clk), .reset(reset), .q(q[2]));
    dff ff3 (.d(next_q[3]), .clk(clk), .reset(reset), .q(q[3]));
endmodule

// ----------------------------------------------------
// Visit Tracker — Dataflow (per-user counters)
// ----------------------------------------------------
module visit_tracker (
    input clk,
    input reset,
    input [3:0] user_id,
    output [7:0] visits
);
    wire [3:0] visit [0:15];
    wire [15:0] enable;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : COUNTERS
            assign enable[i] = (user_id == i);
            counter4 c (.clk(clk), .reset(reset), .enable(enable[i]), .q(visit[i]));
        end
    endgenerate

    assign visits =
        (user_id == 4'd0)  ? {4'b0000, visit[0]}  :
        (user_id == 4'd1)  ? {4'b0000, visit[1]}  :
        (user_id == 4'd2)  ? {4'b0000, visit[2]}  :
        (user_id == 4'd3)  ? {4'b0000, visit[3]}  :
        (user_id == 4'd4)  ? {4'b0000, visit[4]}  :
        (user_id == 4'd5)  ? {4'b0000, visit[5]}  :
        (user_id == 4'd6)  ? {4'b0000, visit[6]}  :
        (user_id == 4'd7)  ? {4'b0000, visit[7]}  :
        (user_id == 4'd8)  ? {4'b0000, visit[8]}  :
        (user_id == 4'd9)  ? {4'b0000, visit[9]}  :
        (user_id == 4'd10) ? {4'b0000, visit[10]} :
        (user_id == 4'd11) ? {4'b0000, visit[11]} :
        (user_id == 4'd12) ? {4'b0000, visit[12]} :
        (user_id == 4'd13) ? {4'b0000, visit[13]} :
        (user_id == 4'd14) ? {4'b0000, visit[14]} :
                             {4'b0000, visit[15]};
endmodule

// ----------------------------------------------------
// Price Calculator — Pure Dataflow (no always)
// ----------------------------------------------------
module price_calculator (
    input [1:0] fluid_type,
    input [7:0] volume_l,
    output [15:0] price
);
    wire [15:0] first_part, second_part;
    wire [15:0] pw, pj, pc;

    assign first_part  = (volume_l <= 1) ? volume_l : 1;
    assign second_part = (volume_l <= 1) ? 0 : (volume_l - 1);

    assign pw = (first_part * 20) + (second_part * 10); // Water
    assign pj = (first_part * 50) + (second_part * 30); // Juice
    assign pc = (first_part * 40) + (second_part * 20); // Chemical

    assign price = (fluid_type == 2'b00) ? pw :
                   (fluid_type == 2'b01) ? pj :
                   (fluid_type == 2'b10) ? pc : 0;
endmodule

// ----------------------------------------------------
// Discount Calculator — Pure Dataflow
// ----------------------------------------------------
module discount_calculator (
    input [7:0] visits,
    input [15:0] price,
    output [7:0] discount_percent,
    output [15:0] final_price
);
    assign discount_percent = (visits <= 2) ? 0 :
                              (visits <= 4) ? 10 : 20;

    assign final_price = price - ((price * discount_percent) / 100);
endmodule

// ----------------------------------------------------
// Stock Manager — Dataflow
// ----------------------------------------------------
module stock_manager (
    input [1:0] fluid_type,
    input [7:0] volume_l,
    output [15:0] remaining_qty,
    output [7:0] message
);
    wire [15:0] water = 100;
    wire [15:0] juice = 80;
    wire [15:0] chemical = 60;

    assign message =
        ((fluid_type == 2'b00) && (volume_l > water))    ? 1 :
        ((fluid_type == 2'b01) && (volume_l > juice))    ? 1 :
        ((fluid_type == 2'b10) && (volume_l > chemical)) ? 1 : 0;

    assign remaining_qty =
        (fluid_type == 2'b00) ? ((volume_l > water) ? water : (water - volume_l)) :
        (fluid_type == 2'b01) ? ((volume_l > juice) ? juice : (juice - volume_l)) :
        (fluid_type == 2'b10) ? ((volume_l > chemical) ? chemical : (chemical - volume_l)) :
                                0;
endmodule

// ----------------------------------------------------
// Top-Level — Fluid Dispenser (Dataflow Connections)
// ----------------------------------------------------
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
    price_calculator pc (
        .fluid_type(fluid_type),
        .volume_l(volume_l),
        .price(original_price)
    );

    discount_calculator dc (
        .visits(visits),
        .price(original_price),
        .discount_percent(discount_percent),
        .final_price(final_price)
    );

    stock_manager sm (
        .fluid_type(fluid_type),
        .volume_l(volume_l),
        .remaining_qty(remaining_qty),
        .message(message)
    );
endmodule
