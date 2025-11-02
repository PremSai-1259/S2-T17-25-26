# 🪙 COIN BASED MULTI FLUID DISPENSER

This project is a Verilog-based digital logic design for a "Coin-Based Multi-Fluid Dispenser." It simulates a machine that dispenses three types of fluids, calculates costs, and applies loyalty discounts based on user visit history.

---

## 👥 Team Details

* **Semester:** 3rd Sem B. Tech. CSE
* **Section:** S2
* **Team ID:** T17
* **Member-1:** B.Charan 241CS215 `charan.241cs215@nitk.edu.in`
* **Member-2:** B.Rohith 241CS219 `rohithbontha.241cs219@nitk.edu.in`
* **Member-3:** Prem Sai 241CS233 `premsai.241cs233@nitk.edu.in`

---

## 🔬 Abstract

**Background:** Beverage dispensing in public spaces such as stations, schools, and workplaces must be both economical and user-friendly. Traditional dispensers are limited to one fluid and require supervision, often leading to wastage or misuse.

**Motivation:** The goal is to design a digital logic-based dispenser that accepts coins, offers multiple fluids, and dispenses quantities according to price–volume proportions. Using sequential and combinational logic, the system can operate autonomously with low cost and high reliability.

**System Features:**
* Supports three fluids: *Water, Utility Chemical, Soft Drink*
* Each fluid follows its own price–volume ratio
* Loyalty discounts based on visit count (up to 50% for water, 20% for chemical, 30% for soft drink)
* Safety features include overflow prevention, refill alerts, and manual refill options

The design demonstrates the integration of **finite state machines** and **digital logic** in a real-world application combining multi-fluid dispensing, dynamic pricing, and customer incentives.

---

## 📊 Functional Block Diagram

![Functional Block Diagram](https://i.imgur.com/example.png)

*(This is a placeholder. Replace the URL with your actual block diagram image.)*

---

## ⚙️ Working

### Project Overview
This Verilog-based system allows users to select a fluid, input volume, and pay using coins. It computes price dynamically, applies loyalty discounts, and updates remaining stock.

### Modules
1.  **visit_tracker:** Tracks each user's number of visits.
2.  **fluid_dispenser:** Calculates price, discount, and remaining stock.
3.  **display_console:** Outputs results in a formatted terminal table.
4.  **testbench:** Integrates and simulates all modules.

### Functional Table

| Step | Inputs | Module | Function Performed | Outputs |
| :--- | :--- | :--- | :--- | :--- |
| 1 | `clk`, `reset` | `visit_tracker` | Initialize or reset counters | `visits = 0` |
| 2 | `user_id` | `visit_tracker` | Increment user's visit count | `visits` (updated) |
| 3 | `fluid_type`, `volume`, `visits` | `fluid_dispenser` | Compute base price | `original_price` |
| 4 | `visits` | `fluid_dispenser` | Determine loyalty discount | `discount_percent` |
| 5 | `price`, `discount` | `fluid_dispenser` | Apply discount | `final_price` |
| 6 | `volume` | `fluid_dispenser` | Update remaining stock | `remaining_qty` |
| 7 | `stock` | `fluid_dispenser` | Generate status message | `message` |
| 8 | All outputs | `display_console` | Display formatted table | Console Output |

### Flowchart
`START` → `Input user_id, fluid_type, volume` → `VISIT TRACKER` → `Update visit count` → `FLUID DISPENSER` → `Compute price, discount, stock` → `DISPLAY CONSOLE` → `Show output table` → `END`

### System Data Flow
* `[clk, reset, user_id]` → `visit_tracker` → `visits`
* `[fluid_type, volume_l, visits]` → `fluid_dispenser` → `display_console`

### Output Parameters
`original_price`, `final_price`, `discount_percent`, `remaining_qty`, `message`

---

## 💡 Logisim Circuit Diagram

*(Placeholder for your Logisim circuit diagram image.)*

![Logisim Circuit Diagram](https://i.imgur.com/example.png)

---

## 💻 Verilog Code

Below is a structural Verilog template for the system.

```verilog
// Module 1: Visit Tracker
module visit_tracker (
    input clk,
    input reset,
    input [7:0] user_id,
    output reg [4:0] visit_count
);
    // Logic to store and increment visit counts per user_id
    // (e.g., using a register array or memory)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset logic
            visit_count <= 0;
        end else begin
            // Logic to find user and increment visit count
        end
    end
endmodule

// Module 2: Fluid Dispenser
module fluid_dispenser (
    input [1:0] fluid_type, // 00=Water, 01=Chemical, 10=Soft Drink
    input [7:0] volume,
    input [4:0] visit_count,
    output reg [9:0] original_price,
    output reg [9:0] final_price,
    output reg [3:0] discount_percent,
    output reg [9:0] remaining_qty,
    output reg [1:0] status // 00=OK, 01=Restock, 10=Overflow
);

    // Internal registers for stock
    reg [9:0] stock_water;
    reg [9:0] stock_chemical;
    reg [9:0] stock_drink;

    // Combinational logic to calculate price based on fluid_type and volume
    // Combinational logic to calculate discount based on visit_count
    // Sequential logic to update stock
    always @(*) begin
        // Price calculation logic
        // Discount logic
        // Final price calculation
        // Stock check and status update
    end

    // Logic to update stock on clock edge (after dispensing)
    always @(posedge clk) begin
        // Update stock_water, stock_chemical, etc.
    end
endmodule

// Module 3: Display Console (Simulation only)
module display_console (
    input clk,
    input [7:0] user_id,
    input [4:0] visits,
    input [1:0] fluid_type,
    input [9:0] original_price,
    input [3:0] discount_percent,
    input [9:0] final_price,
    input [9:0] remaining_qty,
    input [1:0] status
);

    // Use $display or $monitor to print the formatted table
    // This module is typically part of the testbench
    always @(posedge clk) begin
        $display("USER: %d | VISITS: %d | FLUID: %d | ...",
                 user_id, visits, fluid_type /* ... etc. */);
    end
endmodule

// Top-Level Testbench
module tb_multi_fluid_dispenser;

    // Inputs
    reg clk;
    reg reset;
    reg [7:0] user_id;
    reg [1:0] fluid_type;
    reg [7:0] volume;

    // Outputs
    wire [4:0] visit_count;
    wire [9:0] original_price;
    wire [9:0] final_price;
    // ... other wires

    // Instantiate modules
    visit_tracker u_tracker (
        .clk(clk),
        .reset(reset),
        .user_id(user_id),
        .visit_count(visit_count)
    );

    fluid_dispenser u_dispenser (
        .fluid_type(fluid_type),
        .volume(volume),
        .visit_count(visit_count),
        .original_price(original_price),
        .final_price(final_price),
        // ... connect other ports
    );

    display_console u_display (
        .clk(clk),
        .user_id(user_id),
        .visits(visit_count),
        // ... connect other ports
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        reset = 1; #10;
        reset = 0; #10;

        // Test Case 1: User 001, Water
        user_id = 8'd1;
        fluid_type = 2'd0; // Water
        volume = 8'd10;
        #10;

        // Test Case 2: User 002, Soft Drink
        user_id = 8'd2;
        fluid_type = 2'd2; // Soft Drink
        volume = 8'd5;
        #10;
        
        // Test Case 3: User 001 again (check visit count)
        user_id = 8'd1;
        fluid_type = 2'd0; // Water
        volume = 8'd5;
        #10;

        $finish;
    end

endmodule