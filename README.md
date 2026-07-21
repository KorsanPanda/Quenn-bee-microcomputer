# 🐝 Queen Bee Microcomputer

![Language](https://img.shields.io/badge/Language-VHDL-blue.svg)
![Tool](https://img.shields.io/badge/Tool-Xilinx_ISE_14.7-red.svg)
![Architecture](https://img.shields.io/badge/Architecture-RTL_Custom_CPU-green.svg)
![Target](https://img.shields.io/badge/Target-FPGA-orange.svg)

**Queen Bee** is a 16-bit custom microcomputer architecture designed from scratch in VHDL using the Xilinx ISE environment. Developed in hardware using Register-Transfer Level (RTL) principles, this microprocessor is engineered to run a hardware-based **Number Guessing Game** and microcomputer instruction sets directly, without relying on an external CPU.

---

## 📌 Project Overview

This project was developed to materialize computer architecture principles and digital design processes. The system features its own data bus (BUS), register group (Registers), memory unit (RAM/ROM), and control unit.

### Key Features
* **16-bit Instruction & Bus Architecture:** 16-bit wide common data bus (BUS) and instruction structure.
* **Custom Registers:** Hardware registers including `AC` (Accumulator), `PC` (Program Counter), `IR` (Instruction Register), `AR` (Address Register), `TR` (Temporary Register), `INPR` (Input Register), and `OUTR` (Output Register).
* **Arithmetic Logic Unit (ALU):** Handles addition, subtraction, logical operations, and number comparisons.
* **On-Chip Game Logic:** Hardware-level number guessing game logic that compares user input against a target number.
* **FPGA Display & I/O Integration:** 7-Segment Display driver (`segment.vhd`), switch inputs, and LED signaling via UCF pin assignments.

---

## 🏗️ Hardware Architecture & Components

The processor architecture consists of modular VHDL components:

```text
                  +--------------------------+
                  |  Control Unit / Decoder  |
                  +------------+-------------+
                               |
                               v
+---------+      +---------------------------+      +---------+
|  INPR   | ---> |  Common Bus (BUS.vhd)     | ---> |  OUTR   |
| (Inputs)|      +-------------+-------------+      | (LEDs/  |
+---------+                    |                    | Segment)|
                               v                    +---------+
                 +---------------------------+
                 | ALU / AC / PC / AR / TR   |
                 +---------------------------+
                 | RAM / Memory (Memory.vhd) |
                 +---------------------------+
```

### Core VHDL Modules
* **`MAIN.vhd`:** Top-Level entity that integrates all sub-modules (ALU, Registers, Memory, Data Bus).
* **`ALU.vhd`:** Unit responsible for performing arithmetic and logic operations.
* **`BUS.vhd` / `veriyollu.vhd`:** Common data bus managing data flow between registers and memory.
* **`kontrolUnitesi.vhd`:** Controller that decodes instructions and generates timing/interrupt signals.
* **`Memory.vhd` / `ram.vhd`:** Memory structure holding game instructions and data (initialized via `MEMORY.mem`).
* **`segment.vhd` & `LED_switch.vhd`:** I/O modules driving the 7-segment displays and status LEDs on the FPGA.

---

## 💻 Instructions & Memory (`MEMORY.mem`)

The system executes binary instructions loaded from the `MEMORY.mem` file at startup. For example:
* `0111000000001110` : Instruction and data addressing structures.
* The value read from the input register (`INPR`) is compared against the target number through the ALU, and the result is transferred to the displays via `OUTR`.

---

## 🚀 Getting Started

### Prerequisites
* **Xilinx ISE Design Suite 14.7** (or Xilinx Vivado)
* **ISim** (Xilinx Simulator)
* A compatible FPGA Development Board (Spartan / Artix series)

### Simulation & Synthesis Steps

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/USERNAME/Quenn-bee-microcomputer.git](https://github.com/USERNAME/Quenn-bee-microcomputer.git)
   cd Quenn-bee-microcomputer
   ```

2. **Open Project in Xilinx ISE:**
   * Launch Xilinx ISE Project Navigator.
   * Open `KraliceAri.xise` project file.

3. **Run Behavioral Simulation:**
   * Set the view to **Simulation**.
   * Select `MAIN.vhd` or testbench.
   * Double-click **Simulate Behavioral Model** under ISim Simulator.

4. **FPGA Synthesis & Implementation:**
   * Ensure `led.ucf` and `pinsegment.ucf` constraint files are included.
   * Run **Synthesize - XST** and **Implement Design**.
   * Generate Programming File (`.bit`) and download to the target FPGA board.

---

## 📁 Directory Structure

```text
KraliceAri/
├── include / src VHDL Modules/
│   ├── MAIN.vhd             # Top-Level entity connecting all sub-modules
│   ├── ALU.vhd              # Arithmetic Logic Unit
│   ├── BUS.vhd              # Common Data Bus routing
│   ├── kontrolUnitesi.vhd   # Control Unit & FSM logic
│   ├── Memory.vhd           # Internal RAM / ROM memory
│   ├── AC.vhd               # Accumulator Register
│   ├── PC.vhd               # Program Counter Register
│   ├── IR.vhd               # Instruction Register
│   ├── AR.vhd               # Address Register
│   ├── TR.vhd               # Temporary Register
│   ├── INPR.vhd             # Input Register
│   ├── OUTR.vhd             # Output Register
│   ├── segment.vhd          # 7-Segment display controller
│   └── LED_switch.vhd       # Switch input & LED drivers
├── Constraints/
│   ├── led.ucf              # UCF Pin assignments for LEDs
│   └── pinsegment.ucf       # UCF Pin assignments for 7-Segment Display
├── Data/
│   └── MEMORY.mem           # Binary instruction/memory initialization file
├── KraliceAri.xise          # Xilinx ISE Project File
└── README.md
```
