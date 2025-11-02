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
> **Background:**  
> Beverage dispensing in public spaces such as stations, schools, and workplaces must be both economical and user-friendly. Traditional dispensers are limited to one fluid and require supervision, often leading to wastage or misuse.  
>  
> **Motivation:**  
> The goal is to design a digital logic-based dispenser that accepts coins, offers multiple fluids, and dispenses quantities according to price–volume proportions. Using sequential and combinational logic, the system can operate autonomously with low cost and high reliability.  
>  
> **System Features:**  
> - Supports three fluids: *Water, Utility Chemical, Soft Drink*  
> - Each fluid follows its own price–volume ratio  
> - Loyalty discounts based on visit count (up to 50% for water, 20% for chemical, 30% for soft drink)  
> - Safety features include overflow prevention, refill alerts, and manual refill options  
>  
> The design demonstrates the integration of **finite state machines** and **digital logic** in a real-world application combining multi-fluid dispensing, dynamic pricing, and customer incentives.
</details>

## Functional Block Diagram
<details>
  <summary>Detail</summary>
 ```text
COIN-BASED MULTI-FLUID DISPENSER

                  ┌─────────────────────────────┐
                  │       TESTBENCH (tb)        │
                  │  • Generates signals         │
                  │  • Stimulates modules        │
                  │  • Displays final output     │
                  └──────────────┬───────────────┘
                                 │
       ┌─────────────────────────┼─────────────────────────────┐
       │                         │                             │
       ▼                         ▼                             ▼
┌──────────────────┐     ┌────────────────────────┐     ┌───────────────────────┐
│  visit_tracker   │     │   fluid_dispenser      │     │   Display Console     │
│  • Tracks user   │     │  • Calculates price,   │     │  • Prints results in  │
│    visit count   │     │    discount, stock     │     │    tabular format     │
└──────────────────┘     └────────────────────────┘     └───────────────────────┘

MODULE FLOW SEQUENCE:
[Clock ↑ / Reset] → visit_tracker → visits(count)
→ fluid_dispenser → compute(price, discount, stock)
→ print_result (Display) → Console Output Table


</details>

<!-- Third Section -->
## Working
<details>
  <summary>Detail</summary>

 PROJECT OVERVIEW:
This Verilog-based system allows users to select a fluid, input volume, and pay using coins. 
It computes price dynamically, applies loyalty discounts, and updates remaining stock.

MODULES:
1. visit_tracker — Tracks each user's number of visits  
2. fluid_dispenser — Calculates price, discount, and remaining stock  
3. display_console — Outputs results in a formatted terminal table  
4. testbench — Integrates and simulates all modules

FUNCTIONAL TABLE:

| Step | Inputs                     | Module          | Function Performed                       | Outputs             |
|------|----------------------------|-----------------|------------------------------------------|---------------------|
| 1    | clk, reset                 | visit_tracker   | Initialize or reset counters             | visits = 0          |
| 2    | user_id                    | visit_tracker   | Increment user's visit count             | visits (updated)    |
| 3    | fluid_type, volume, visits | fluid_dispenser | Compute base price                       | original_price      |
| 4    | visits                     | fluid_dispenser | Determine loyalty discount               | discount_percent    |
| 5    | price, discount            | fluid_dispenser | Apply discount                           | final_price         |
| 6    | volume                     | fluid_dispenser | Update remaining stock                   | remaining_qty       |
| 7    | stock                      | fluid_dispenser | Generate status message                  | message             |
| 8    | All outputs                | display_console | Display formatted table                  | Console Output      |

FLOWCHART:

START → Input user_id, fluid_type, volume  
→ VISIT TRACKER → Update visit count  
→ FLUID DISPENSER → Compute price, discount, stock  
→ DISPLAY CONSOLE → Show output table → END

SYSTEM DATA FLOW:
[clk, reset, user_id] → visit_tracker → visits  
[fluid_type, volume_l] → fluid_dispenser → display_console

OUTPUT PARAMETERS:
original_price, final_price, discount_percent, remaining_qty, message

FINAL TERMINAL OUTPUT:

USER | VISITS | FLUID | ORIGINAL | DISC | FINAL | REMAIN | STATUS  
-----|---------|--------|----------|------|--------|--------|--------  
001  |   03   |  01   |   ₹120   | 10%  |  ₹108  |  85L   |  OK  
002  |   05   |  10   |   ₹200   | 20%  |  ₹160  |  70L   |  RESTOCK
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