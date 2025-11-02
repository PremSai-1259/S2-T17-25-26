# COIN BASED MULTI FLUID DISPENSER

<!-- First Section -->
## Team Details
<details>
  <summary>Detail</summary>

  > Semester: 3rd Sem B. Tech. CSE

  > Section: S2

  > Team ID: T17

  > Member-1: B.Charan 241CS215  charan.241cs215@nitk.edu.in

  > member-2: B.Rohith 241CS219  rohithbontha.241cs219@nitk.edu.in

  > Member-3: Prem Sai 241CS233  premsai.241cs233@nitk.edu.in
</details>

<!-- Second Section -->
## Abstract
<details>
  <summary>Detail</summary>
>Background: Beverage dispensing in public spaces such as stations, schools, and workplaces must
be both economical and user-friendly. Traditional dispensers are usually limited to a single liquid,
require supervision, and often lead to wastage or unequal usage. There is a strong need for an
automated and flexible solution that can dispense multiple fluids, maintain hygiene, and ensure
cost-effective operation.
Motivation: With increasing demand for self-service machines, the aim is to design a dispenser
that accepts coin denominations, allows users to choose from multiple fluids, and delivers the required
quantity according to predefined price–volume proportions. By embedding this functionality through
digital logic and finite state machines, the system becomes low-cost, reliable, and suitable for large-
scale deployment without continuous monitoring.
System Features and Contribution: The proposed design supports three distinct fluids —
water, a utility chemical, and a soft drink. Each fluid follows its own pricing-to-volume
proportion. For example, water may be supplied at progressively reduced rates for higher volumes,
ensuring affordability for daily usage, while the chemical and soft drink follow different proportion
scales based on their nature and cost.
To encourage repeated use, the system also introduces a progressive discount mechanism.
A customer’s first transaction is charged at the standard rate. On subsequent visits, discounts are
1
applied in steps of 10% until a maximum threshold is reached. The maximum allowable discount is
fluid-specific: up to 50% for water, 20% for the chemical, and 30% for the soft drink. This ensures
fair pricing while rewarding loyal customers and preventing misuse.
Additional safety and reliability features include overflow prevention, low-level indicators
for refilling tanks, and a manual refill option. Altogether, the project demonstrates how
combinational and sequential logic can be integrated into a real-life application that combines multi-
fluid dispensing, pricing flexibility, and customer-oriented incentives in a single system.
</details>

## Functional Block Diagram
<details>
  <summary>Detail</summary>
 
>================================================================================
                     COIN-BASED MULTI-FLUID DISPENSER
================================================================================

                      ┌────────────────────────────────┐
                      │          TESTBENCH (tb)        │
                      │────────────────────────────────│
                      │ Function:                      │
                      │  - Generates signals           │
                      │  - Stimulates modules          │
                      │  - Displays final output       │
                      └──────────────┬─────────────────┘
                                     │
         ┌───────────────────────────┼────────────────────────────┐
         │                           │                            │
         ▼                           ▼                            ▼
 ┌──────────────────┐       ┌──────────────────────────┐     ┌──────────────────────────────┐
 │   visit_tracker  │       │     fluid_dispenser      │     │       Display Console        │
 │──────────────────│       │──────────────────────────│     │──────────────────────────────│
 │ Function:        │       │ Function:                │     │ Function:                    │
 │  - Tracks user   │       │  - Calculates price,     │     │  - Prints results in         │
 │    visits count  │       │    discount, stock       │     │    tabular format            │
 └──────────────────┘       └──────────────────────────┘     └──────────────────────────────┘



================================================================================
                              MODULE FLOW SEQUENCE
================================================================================

   [Clock ↑ or Reset] 
            │
            ▼
     visit_tracker
        │
        ▼
   visits (count)
        │
        ▼
   fluid_dispenser
        │
        ▼
   Compute Price + Discount + Stock
        │
        ▼
   print_result (Display)
        │
        ▼
   Console Output Table

================================================================================



</details>

<!-- Third Section -->
## Working
<details>
  <summary>Detail</summary>

  > ```text
================================================================================
                     COIN-BASED MULTI-FLUID DISPENSER
================================================================================

📘 PROJECT OVERVIEW
--------------------------------------------------------------------------------
This Verilog-based model simulates an automated **Coin-Based Multi-Fluid Dispenser**
system that allows users to select a type of fluid, specify a quantity, and pay 
using coins. The system calculates the price dynamically, applies discounts 
based on user loyalty (number of visits), and updates available fluid stock.

It is composed of three main modules:
1. **visit_tracker**  → Tracks the number of visits per user.
2. **fluid_dispenser** → Calculates prices, discounts, and remaining stock.
3. **display_console** → Displays the formatted output in the terminal.

The **testbench** integrates all modules, drives input signals, and monitors
output results for verification.

================================================================================
                       FUNCTIONAL TABLE — MODULE OPERATION
================================================================================
| Step | Input Signals                         | Module Activated     | Function Performed                              | Output Signals                        |
|------|---------------------------------------|----------------------|--------------------------------------------------|----------------------------------------|
|  1   | clk, reset                            | visit_tracker        | Initializes or resets visit counts               | visits = 0                             |
|  2   | user_id entered                       | visit_tracker        | Increments visit count for given user            | visits (updated)                       |
|  3   | fluid_type, volume_l, visits          | fluid_dispenser      | Calculates price based on fluid type & volume    | original_price                         |
|  4   | visits                                | fluid_dispenser      | Determines discount based on loyalty (visits)    | discount_percent                       |
|  5   | discount_percent, original_price      | fluid_dispenser      | Applies discount and updates final price         | final_price                            |
|  6   | volume_l                              | fluid_dispenser      | Updates remaining fluid stock                    | remaining_qty                          |
|  7   | remaining_qty                         | fluid_dispenser      | Generates message (OK / RESTOCK)                 | message                                |
|  8   | All outputs                           | Display Console      | Prints all results neatly in terminal            | Console Table Output                   |
================================================================================


================================================================================
                           FLOWCHART (ASCII REPRESENTATION)
================================================================================

                 ┌────────────────────────────────────┐
                 │          START (RESET=0)           │
                 └────────────────────────────────────┘
                                 │
                                 ▼
                 ┌────────────────────────────────────┐
                 │     Input user_id, fluid_type,     │
                 │          and volume_l              │
                 └────────────────────────────────────┘
                                 │
                                 ▼
                 ┌────────────────────────────────────┐
                 │        VISIT TRACKER MODULE         │
                 │   → Update user visit count         │
                 └────────────────────────────────────┘
                                 │
                                 ▼
                 ┌────────────────────────────────────┐
                 │        FLUID DISPENSER MODULE       │
                 │   → Calculate original price        │
                 │   → Apply discount (based on visits)│
                 │   → Compute final price             │
                 │   → Update remaining stock          │
                 │   → Generate status message         │
                 └────────────────────────────────────┘
                                 │
                                 ▼
                 ┌────────────────────────────────────┐
                 │         DISPLAY CONSOLE             │
                 │   → Print results:                  │
                 │     User | Visits | Fluid | Prices  │
                 │     Discount | Stock | Message      │
                 └────────────────────────────────────┘
                                 │
                                 ▼
                 ┌────────────────────────────────────┐
                 │               END                  │
                 └────────────────────────────────────┘
================================================================================


================================================================================
                           SYSTEM DATA FLOW SUMMARY
================================================================================

   [clk, reset, user_id] ─────────▶ visit_tracker
             visits ──────────────▶ fluid_dispenser
   [fluid_type, volume_l] ───────▶ fluid_dispenser
             outputs ─────────────▶ display_console

Output Parameters:
  → original_price
  → final_price
  → discount_percent
  → remaining_qty
  → message

================================================================================
                           FINAL TERMINAL OUTPUT FORMAT
================================================================================

USER | VISITS | FLUID | ORIGINAL PRICE | DISCOUNT | FINAL PRICE | REMAINING | STATUS
------------------------------------------------------------------------------------
001  |   03   |  01   |     ₹120       |   10%    |     ₹108     |   85L     |  OK
002  |   05   |  10   |     ₹200       |   20%    |     ₹160     |   70L     |  RESTOCK
================================================================================

</details>

<!-- Fourth Section -->
## Logisim Circuit Diagram
<details>
  <summary>Detail</summary>

  > Update a neat logisim circuit diagram
</details>

<!-- Fifth Section -->
## Verilog Code
<details>
  <summary>Detail</summary>

  > Neatly update the Verilog code in code style only.
</details>

## References
<details>
  <summary>Detail</summary>
  
> BBC News. *India train crash: At least 275 dead in Odisha, 2023*. Accessed: 2024-09-30.  
   [(https://www.bbc.com/news)](https://www.bbc.com/news/world-asia-india-65793257)
   
</details>