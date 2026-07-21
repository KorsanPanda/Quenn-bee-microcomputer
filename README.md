# 🐝 Queen Bee Microcomputer (Custom VHDL CPU Architecture)

![Language](https://img.shields.io/badge/Language-VHDL-blue.svg)
![Tool](https://img.shields.io/badge/Tool-Xilinx_ISE-red.svg)
![Architecture](https://img.shields.io/badge/Architecture-RTL_Custom_Processor-green.svg)
![Target](https://img.shields.io/badge/Target-FPGA-orange.svg)

**Queen Bee** is a custom hardware-level microprocessor architecture implemented in **VHDL**. Designed directly at the Register-Transfer Level (RTL), this system features a custom control unit, dedicated register array, multiplexed common data bus, and hardware execution logic for running a **Number Guessing Game** loaded via memory configuration files (`MEMORY.mem`).

---

## 📌 System Architecture & Features

The processor executes instructions via a sequence-based ring counter (`SAYAC.vhd`, timing states $t_0$ through $t_5$) and a central control unit (`kontrolUnitesi.vhd`).

### Key Components & Bit Widths
* **Top-Level Unit (`MAIN.vhd`):** Connects all registers, ALU, RAM, sequence counter, and bus routing logic.
* **16-bit Common Data Bus (`veriyollu.vhd` & `MUX.vhd`):** Multiplexer-based internal bus interconnecting registers and memory.
* **Register Set:**
  * **`IR.vhd` (Instruction Register):** 16-bit register storing opcode ($Bit[13..11]$), addressing mode ($Bit[15..14]$), and target address ($Bit[10..0]$).
  * **`AC.vhd` (Accumulator):** 4-bit register for intermediate arithmetic/logic results.
  * **`AR.vhd` (Address Register):** 11-bit memory addressing register.
  * **`PC.vhd` (Program Counter):** 11-bit sequential program execution counter.
  * **`TR.vhd` (Temporary Register):** 4-bit temporary operand storage.
  * **`INPR.vhd` & `OUTR.vhd`:** Input/Output registers for switch inputs and LED/Display outputs.
* **Arithmetic Logic Unit (`ALU.vhd`):** Performs addition, bitwise AND/OR/NOT, and hardware-level comparison operations between `AC`, `TR`, and `INPR`.
* **Memory Unit (`ram.vhd` & `MEMORY.mem`):** Internal RAM initialized with binary instructions and game constants.
* **FPGA Constraints (`pinsegment.ucf` & `led.ucf`):** Physical pin bindings for 7-Segment displays and I/O switches.

---

## 🏗️ Hardware Block Diagram

```text
                  +--------------------------------+
                  |    Sequence Counter (SAYAC)    |
                  |     (Timing Signals t0-t5)     |
                  +---------------+----------------+
                                  |
                                  v
+---------------+  +-------------------------------+  +---------------+
| Input Switches|  |    Control Unit & Decoder     |  | 7-Segment /   |
|  (INPR.vhd)   |->|      (kontrolUnitesi.vhd)     |->| LEDs (OUTR /  |
+---------------+  +---------------+---------------+  | segment.vhd)  |
                                   |                  +---------------+
                                   v
+---------------------------------------------------------------------+
|                  16-bit Common Data Bus (veriyollu.vhd)             |
+-------+---------------+---------------+---------------+-------------+
        |               |               |               |
        v               v               v               v
  +-----------+   +-----------+   +-----------+   +-----------+
  |  PC / AR  |   |    IR     |   |  ALU / AC |   | RAM Block |
  | (11-bit)  |   | (16-bit)  |   |  (4-bit)  |   | (ram.vhd) |
  +-----------+   +-----------+   +-----------+   +-----------+
```

---

## 💻 Memory & Instruction Format (`MEMORY.mem`)

Instructions are encoded in 16-bit binary formats:
* **Bits [15..14]:** Addressing Mode (`00`: Direct, `01`: Indirect, `10`: Immediate, `11`: Register Command).
* **Bits [13..11]:** Opcode (e.g., `000`: AND, `001`: OR, `101`: ADD, `110`: LDA, `111`: Register Operation).
* **Bits [10..0]:** Memory Address or Register Command Flags (`reg_cmd`).

---

## 🚀 Getting Started

### Prerequisites
* **Xilinx ISE Design Suite** (or Vivado with VHDL-93/2002 support)
* ISim / ModelSim Simulator
* Target FPGA board (e.g., Spartan-6 or Artix-7)

### Synthesis & Simulation Steps

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/KorsanPanda/quenn-bee-microcomputer.git](https://github.com/KorsanPanda/quenn-bee-microcomputer.git)
   cd quenn-bee-microcomputer
   ```

2. **Open Project in Xilinx ISE:**
   * Create a new project pointing to the repository root directory.
   * Add all `.vhd` source files and select `MAIN.vhd` as the Top-Level Entity.
   * Add physical constraint files (`pinsegment.ucf` and `led.ucf`).

3. **Run Simulation:**
   * Set view to **Simulation**.
   * Run behavioral simulation on `MAIN.vhd` or individual testbenches.

4. **Generate Bitstream:**
   * Run **Synthesize - XST** followed by **Implement Design**.
   * Generate Bitstream (`.bit`) and flash to your FPGA hardware.

---

## 📁 Directory Structure

```text
korsanpanda-quenn-bee-microcomputer/
├── MAIN.vhd             # Top-Level entity connecting all CPU modules
├── veriyollu.vhd        # 16-bit multiplexed common bus implementation
├── ALU.vhd              # Arithmetic Logic Unit
├── IR.vhd               # 16-bit Instruction Register and instruction decoder
├── AC.vhd               # 4-bit Accumulator Register
├── AR.vhd               # 11-bit Address Register
├── PC.vhd               # 11-bit Program Counter Register
├── TR.vhd               # 4-bit Temporary Register
├── INPR.vhd             # 4-bit Input Register
├── OUTR.vhd              # Output Register driving external display logic
├── ram.vhd              # RAM block module
├── SAYAC.vhd            # Ring counter generating t0-t5 timing signals
├── MUX.vhd              # Bus multiplexer primitive
├── segment.vhd          # 7-Segment display driver
├── LED_switch.vhd       # Board switch/LED interface
├── kontrolUnitesi.vhd   # CPU Control Unit
├── pinsegment.ucf       # UCF pin locations for 7-Segment display
├── led.ucf              # UCF pin locations for board LEDs/switches
├── MEMORY.mem           # Binary instruction memory initialization file
└── README.md            # System documentation
```
