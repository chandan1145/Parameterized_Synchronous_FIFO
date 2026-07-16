📌 Project Overview

• This project implements a fully parameterized, synthesizable Synchronous FIFO (First-In, First-Out) memory queue in Verilog HDL and verifies its functionality using a rigorous SystemVerilog testbench suite. 

• The architecture is tailored for high-speed, single-clock data buffering between internal digital design blocks, incorporating overflow protection, dynamic pointer width evaluation, and robust boundary status tracking flags.

🏗️ Architecture

• The accelerator consists of the following modules:
• Parameterized Matrix Memory Array
• Write Pointer Control Logic
• Read Pointer Control Logic
• Status Flag Generator (`full`, `empty`)
• Safety Overflow Lock

📷 Architecture Diagram
<img width="2816" height="1536" alt="architecture" src="https://github.com/user-attachments/assets/89bed862-dd18-497b-8c54-d7951d1ad36f" />

📷 Animation of Architecture diagram


https://github.com/user-attachments/assets/ed078366-23be-4517-9e6a-558f83197ac8




🧠 RTL Design

• Written entirely in synthesizable Verilog HDL
• Modular pipelined architecture
• Phase Inversion Flag Strategy (utilizes an extra pointer MSB to accurately distinguish between Full and Empty states without resource-heavy counter modules)
• Robust Boundary Handling (automatically isolates and discards accidental overflow write cycles to ensure internal data integrity)

RTL Source Files:

`Parameterized_Synchronous_FIFO.srcs/`
├── `sources_1/new/sync_fifo.v` (Synthesizable FIFO Core Logic)
└── `sim_1/new/sync_fifo_tb.sv` (SystemVerilog Automated Testbench Suite)

📊 Simulation & Verification

• Functional verification performed using waveform analysis in Xilinx Vivado XSIM.
• Verified handshake correctness and reset state validation
• Validated flag logic transitions under consecutive read/write sequences
• Confirmed overflow protection blocks data injection at maximum capacity
• Ensured no X-propagation in final validated simulation

📷 Waveform Verification

 <img width="1311" height="783" alt="image" src="https://github.com/user-attachments/assets/f2b8416c-67b6-4a0c-84a7-f09639f7fafd" />


📦 Generated Outputs & Directory Structure

• Located in:
`Parameterized_Synchronous_FIFO/`
├── `Parameterized_Synchronous_FIFO.xpr` (Main Vivado Project File)
├── `Parameterized_Synchronous_FIFO.srcs/` (Active HDL Source Registries)
│   ├── `sources_1/` (RTL Design Module Path)
│   └── `sim_1/` (SystemVerilog Testbench Path)
└── `Parameterized_Synchronous_FIFO.sim/` (XSIM Compilation Workspace logs)

📈 Design Metrics

• Target Device: AMD Artix-7 xc7a35tcpg236-1
• Data Width Capacity:** 8-bit default parallel bus
• Memory Register Footprint:** 16 allocation slots ($16 \times 8$ memory matrix)
• Address Pointer Resolution:** 4-bit indexing paths + 1 phase bit ($5$ bits total tracking width)
• Clock Domain Environment:** Single-source Synchronous Clock Tree topology

🎯 Key Learnings

• FIFO Boundary Tracking using MSB phase inversion wrapping techniques
• Writing scalable hardware architectures using `$clog2` system functions for automatic pointer width calculation
• Constructing SystemVerilog verification scripts with `$urandom_range` stimulus loops
• Handling complete design workflows, directory trees, and wave viewer tools within Vivado
• Leveraging industrial Git commands to deploy hardware engineering workspaces

🛠️ Tools Used

• Verilog HDL
• SystemVerilog
• Xilinx Vivado 2025.2
• Vivado XSIM Engine
• Git & PowerShell

🚀 Status

✅ RTL Design Architecture Complete  
✅ Automated Testbench Complete  
✅ Functional Timeline Verification Complete  
✅ Zero X-Propagation or Core Flag Inversions Detected  

👨‍💻 Author
Chandan M 
Electronics & VLSI Engineering student

