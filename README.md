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

![Functional Block Diagram](.Snapshots/block.png)

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


```verilog
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
```
---

## References

1. M. Morris Mano, Digital Design, Pearson, 5th Edition, 2013.
2. R. J. Tocci, N. S. Widmer, Digital Systems: Principles and Applications, Pearson, 10th Edition
3. A. Kumar, Fundamentals of Digital Circuits, PHI Learning, 4th Edition, 2016.
4. IEEE Xplore Digital Library, https://ieeexplore.ieee.org
5. ResearchGate, Coin-operated dispensing system articles, https://www.researchgate.net
