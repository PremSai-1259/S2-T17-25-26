`timescale 1ns/1ps

module tb_dataflow;
    reg clk, reset;
    reg [3:0] user_id;
    reg [1:0] fluid_type;
    reg [7:0] volume_l;
    wire [7:0] visits;
    wire [15:0] original_price, final_price, remaining_qty;
    wire [7:0] discount_percent, message;

    // Instantiate visit tracker
    visit_tracker tracker (
        .clk(clk),
        .reset(reset),
        .user_id(user_id),
        .visits(visits)
    );

    // Instantiate main dispenser
    fluid_dispenser dispenser (
        .fluid_type(fluid_type),
        .volume_l(volume_l),
        .visits(visits),
        .original_price(original_price),
        .final_price(final_price),
        .discount_percent(discount_percent),
        .remaining_qty(remaining_qty),
        .message(message)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Simulation sequence
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;

        $display("\n=================================================================================================================");
        $display("| USER | VISIT |   FLUID    | VOL(L) | DISC(%%) | ORIG PRICE(Rs) | FINAL PRICE(Rs) | REMAINING STOCK(L) |  STATUS  |");
        $display("-----------------------------------------------------------------------------------------------------------------");

        // USER 1 - Water 1L
        user_id = 1; fluid_type = 2'b00; volume_l = 1; #10;
        print_result("Water");

        // USER 2 - Water 2L
        user_id = 2; fluid_type = 2'b00; volume_l = 2; #10;
        print_result("Water");

        // USER 3 - Juice 1L
        user_id = 3; fluid_type = 2'b01; volume_l = 1; #10;
        print_result("Juice");

        // USER 4 - Chemical 3L
        user_id = 4; fluid_type = 2'b10; volume_l = 3; #10;
        print_result("Chemical");

        // USER 1 again - Water 2L
        user_id = 1; fluid_type = 2'b00; volume_l = 2; #10;
        print_result("Water");

        // USER 1 again - Juice 5L
        user_id = 1; fluid_type = 2'b01; volume_l = 5; #10;
        print_result("Juice");

        // USER 6 - Chemical 70L (Exceeds stock)
        user_id = 6; fluid_type = 2'b10; volume_l = 70; #10;
        print_result("Chemical");

        $display("=================================================================================================================\n");
        $finish;
    end

    // Task for formatted table row output
    task print_result;
        input [80*8:1] fluid_name;
        begin
            if (message == 1) begin
                $display("| %-4d | %-5d | %-10s | %-6d |   --   |       --        |       --        |        --         | %-10s |",
                         user_id, visits, fluid_name, volume_l, "Restock Needed");
            end else begin
                $display("| %-4d | %-5d | %-10s | %-6d | %-6d | %-15d | %-15d | %-17d | %-8s       |",
                         user_id, visits, fluid_name, volume_l,
                         discount_percent, original_price, final_price,
                         remaining_qty, "OK");
            end
        end
    endtask
endmodule
