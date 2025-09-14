# Single-Port Synchronous RAM (Verilog)

## Project Overview
This project implements a **single-port synchronous RAM** in Verilog with a bidirectional data bus.  
The design supports:
- Parameterizable **address width**, **data width**, and **depth**
- **Synchronous read/write** operations
- **Tristate inout data bus**
- Testbench for functional verification

The project is structured for easy use in **Vivado (Windows)** 

---

##  Design Details

### Top Module: `single_port_sync_ram.v`
- **Parameters**
  - `ADDR_WIDTH`: Address bus width (default: 4 → 16 locations)
  - `DATA_WIDTH`: Data bus width (default: 32 bits)
  - `DEPTH`: Memory depth (default: 16)

- **Ports**
  | Name | Direction | Description |
  |------|-----------|-------------|
  | `clk`  | input  | System clock |
  | `addr` | input  | Address bus |
  | `data` | inout  | Bidirectional data bus |
  | `cs`   | input  | Chip select |
  | `we`   | input  | Write enable |
  | `oe`   | input  | Output enable |

---

##  Testbench: `tb_single_port_sync_ram.v`
The testbench performs:
1. **Write phase**: Writes data into multiple RAM locations.  
2. **Read phase**: Reads back stored data with `oe=1, we=0`.  
3. **Waveform logging**: Generates WCFG files for viewing.  
4. **Console output**: Displays read values using `$display`.

---

##  How to Run (Vivado on Windows)

1. Open **Vivado** → `File → New Project`.  
2. Add files from `src/` and `tb/`.  
3. Set the testbench (`tb_single_port_sync_ram.v`) as the top module for simulation.  
4. Run: `Run Simulation → Run Behavioral Simulation`.    
5. To capture an image:  
   - Take a screenshot (`Win + Shift + S`) and save as `sim/ram_waveform.png`.

---

##  Project Structure
single_port_sync_ram_project/
├── src/
│ └── single_port_sync_ram.v
├── tb/
│ └── tb_single_port_sync_ram.v
├── sim/
│ ├── waveform.wcfg
│ └── ram_waveform.png
├── constraints/
│ └── top.xdc # (if FPGA implementation needed only defined clk constrain )
├── README.md

---

##  Simulation Results
### Console Output
Example simulation log:
Starting write operations...
Starting read operations...
Read @0 = AAAABBBB
Read @1 = 12345678
Read @2 = DEADBEEF
Read @3 = FACECaFE
Test completed.

---

### Waveform
![RAM Waveform](single_port_sync_ram%20/4.sim/single_port_sync_ram.png)

---

## 🚀 Future Enhancements
- Add **asynchronous read** support  
- Extend to **dual-port RAM**  
- FPGA synthesis with constraint file  

---

## 📜 License
This project is open-source. Feel free to fork, modify, and use for learning or interviews.
