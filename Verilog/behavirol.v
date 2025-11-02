module visit_tracker(
    input clk,
    input reset,
    input [3:0] user_id,
    output reg [7:0] visits
);
    reg [7:0] user_visits [0:15]; // stores visit count per user
    integer idx;

    // Reset all visits
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (idx = 0; idx < 16; idx = idx + 1)
                user_visits[idx] <= 0;
        end
        else begin
            user_visits[user_id] <= user_visits[user_id] + 1;
        end
    end

    // Output current user's visits
    always @(*) begin
        visits = user_visits[user_id];
    end
endmodule


module fluid_dispenser(
    input [1:0] fluid_type,   // 00 = Water, 01 = Juice, 10 = chemical
    input [7:0] volume_l,     // volume in litres
    input [7:0] visits,
    output reg [15:0] original_price,
    output reg [15:0] final_price,
    output reg [7:0] discount_percent,
    output reg [15:0] remaining_qty,
    output reg [7:0] message
);

    // Stocks (in litres)
    reg [15:0] water_stock;
    reg [15:0] juice_stock;
    reg [15:0] chemical_stock;

    real volume;
    real price;
    real first_part;
    real second_part;

    initial begin
        water_stock = 100;
        juice_stock = 80;
        chemical_stock = 60;
    end

    always @(*) begin
        volume = volume_l;
        first_part = (volume >= 1.0) ? 1.0 : volume;
        second_part = (volume > 1.0) ? (volume - 1.0) : 0.0;
        price = 0;

        case (fluid_type)
            2'b00: begin // Water
                if (water_stock < volume) begin
                    message = 1;
                end
                else begin
                    price = (first_part * 1000 * 2 / 100) + (second_part * 1000 * 1 / 100);
                    water_stock = water_stock - volume;
                    message = 0;
                end
                remaining_qty = water_stock;
            end
            2'b01: begin // Juice
                if (juice_stock < volume) begin
                    message = 1;
                end
                else begin
                    price = (first_part * 1000 * 5 / 100) + (second_part * 1000 * 3 / 100);
                    juice_stock = juice_stock - volume;
                    message = 0;
                end
                remaining_qty = juice_stock;
            end
            2'b10: begin // chemical
                if (chemical_stock < volume) begin
                    message = 1;
                end
                else begin
                    price = (first_part * 1000 * 4 / 100) + (second_part * 1000 * 2 / 100);
                    chemical_stock = chemical_stock - volume;
                    message = 0;
                end
                remaining_qty = chemical_stock;
            end
            default: message = 1;
        endcase

        // Discount logic
        if (visits <= 2)
            discount_percent = 0;
        else if (visits <= 4)
            discount_percent = 10;
        else
            discount_percent = 20;

        original_price = price;
        final_price = price - (price * discount_percent / 100);
    end
endmodule
