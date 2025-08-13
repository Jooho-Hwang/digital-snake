# Digital Snake on FPGA (Verilog)

A grid-based Snake game implemented in Verilog HDL for FPGA boards.  
This design outputs to a VGA display (640×480@60Hz), processes button inputs, and renders the game in real time without a frame buffer.

> **Note:** This repository follows a *single clock domain + enable pulses* architecture for stable simulation and synthesis.

## Overview

- **Display:** VGA 640×480@60 Hz (live rendering)
- **Controls:** 4 directional push buttons (LEFT, RIGHT, UP, DOWN)
- **Core:** Grid-based snake movement, apple spawning (LFSR), wall collision
- **Scalability:** Easily extendable for score display, PS/2 keyboard, or VRAM-based rendering
- **Architecture:** Modular, synthesis-friendly, single base clock

## Architecture

![Block Diagram](docs/block%20diagram.png)

**Main Components:**

1. **Input Handling**
   - **sync_2ff** – Synchronizes asynchronous push button inputs to the system clock.
   - **debounce** – Filters mechanical bounce from button signals.
   - **direction_ctrl** – Converts button states into a 2-bit direction code.

2. **Enable Generation**
   - **clk_en_gen** – Generates `pix_en` (pixel clock enable), `game_en` (game tick), and `debounce_en` pulses from the system clock.

3. **VGA Pipeline**
   - **vga_timing** – Produces horizontal/vertical counters, sync signals, and display enable (DE).
   - **vga_addr_dec** – Converts pixel counters to grid cell coordinates (`gx`, `gy`).
   - **renderer** – Maps grid coordinates to RGB values (simple background/border in minimal build).
   - **vga_rgb_out** – Gates RGB output by DE before sending to VGA pins.

4. **Game Core**
   - **game_fsm** – Manages game states (IDLE, RUN, PAUSE, DEAD).
   - **snake_core** – Updates snake head/body position based on direction and game tick.
   - **apple_gen_lfsr** – Generates pseudo-random apple positions.
   - **collision_check** – Detects collisions with walls (and future self-body collisions).

5. **External Interfaces**
   - **Inputs:** `clk`, `rst_n`, `btn[3:0]` (direction buttons)
   - **Outputs:** `vga_hs`, `vga_vs`, `vga_rgb`

## Directory Structure

```bash
root/
├─ src/ # Top-level integration and board config
├─ rtl/
│ ├─ infra/ # Clock enable, sync, debounce, global defs
│ ├─ periph/
│ │ ├─ vga/ # VGA timing, address decode
│ │ └─ display/ # RGB output gating
│ └─ core/ # Game FSM, snake logic, rendering
├─ sim/ # Testbenches (smoke tests)
├─ constr/ # FPGA constraints (XDC, pin CSV)
└─ docs/ # Block diagram
```

## How to Build & Run

### Synthesis

1. Open your FPGA vendor tool (Vivado, Quartus, etc.).
2. Add all Verilog source files from `src/` and `rtl/`.
3. Apply constraints from `constr/digital_snake.xdc`.
4. Generate bitstream and program your FPGA board.

### Simulation

- Requires **Icarus Verilog**, **Verilator**, or vendor simulator.
- Example (Icarus Verilog):
  ```bash
  iverilog -o tb_vga_timing sim/tb_vga_timing.v rtl/infra/*.v rtl/periph/vga/*.v
  vvp tb_vga_timing
  ```

## Modules

| Module | Description |
|---|---|
| `src/top_digital_snake.v` | Top-level integration of all subsystems |
| `rtl/infra/clk_en_gen.v` | Generates pixel/game/debounce enables |
| `rtl/infra/sync_2ff.v` | Synchronizes async inputs |
| `rtl/infra/debounce.v` | Debounces button inputs |
| `rtl/periph/vga/vga_timing.v` | Generates VGA sync and counters |
| `rtl/periph/vga/vga_addr_dec.v` | Maps pixel coordinates to grid cells |
| `rtl/periph/display/vga_rgb_out.v` | Gates RGB output by active display area |
| `rtl/core/game_fsm.v` | Controls game states (IDLE, RUN, PAUSE, DEAD) |
| `rtl/core/direction_ctrl.v` | Handles direction changes from inputs |
| `rtl/core/snake_core.v` | Snake movement and game tick processing |
| `rtl/core/apple_gen_lfsr.v` | Pseudo-random apple position generator |
| `rtl/core/collision_check.v` | Detects wall collisions |
| `rtl/core/renderer.v` | Maps grid cells to RGB colors |

## Constraints

Clock: System clock frequency defined in board_config.vh.

VGA: 640×480@60 Hz timing from defs.vh.

Buttons: Active-high push buttons, debounced in logic.

Pin Mapping: See constr/board_pins.csv and digital_snake.xdc.

## How to Test

### Simulation

Run tb_vga_timing.v to verify VGA sync/DE timing.

Run tb_snake_core_step.v to verify basic core tick/direction changes.

### On Hardware

Load bitstream to FPGA board.

Connect VGA monitor.

Press directional buttons to move the snake border demo.

## Lessons Learned

Single clock + enable pulses simplify timing closure and simulation.

Grid coordinate system makes rendering and collision detection straightforward.

Minimal build works without external memory; VRAM/framebuffer can be added later.

Modular structure allows easy feature upgrades (e.g., PS/2, score display).
