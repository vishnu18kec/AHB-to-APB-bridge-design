# 🟢 AHB to APB Bridge Design (Verilog)

---

## 📌 Project Overview

This project implements an **AHB to APB Bridge** in Verilog. The bridge enables communication between an **Advanced High-performance Bus (AHB)** master and multiple **Advanced Peripheral Bus (APB)** slaves, supporting read/write transactions, byte enables, and proper handshake control.

The design is modular and includes:  
- AHB Request Capture  
- Address Decoder  
- Byte-Enable Generator  
- APB Master Controller  
- Top-level Bridge Module  
- Simple APB Slave Model for simulation  

---

## ⚙️ Features

- Capture AHB transfer fields and convert them to APB protocol signals.  
- Supports multiple APB slave devices with address decoding.  
- Generates proper byte enables for varying HSIZE values.  
- Implements APB master FSM with handshake support.  
- Fully synthesizable Verilog code compatible with most FPGA/ASIC flows.  
- Testbench included for verification of read and write transactions.  

---

## 🧩 Modules

### 1️⃣ AHB Request Capture (`ahb_req_capture`)
Captures AHB transfer signals and generates request signals for the APB controller.

### 2️⃣ Byte-Enable Generator (`byte_en_generator`)
Generates APB byte-enable lanes based on AHB HSIZE and HADDR.

### 3️⃣ Address Decoder (`addr_decode`)
Decodes the address from AHB into a one-hot selection signal for multiple APB slaves.

### 4️⃣ APB Master Controller (`apb_master_ctrl`)
Finite State Machine (FSM) that controls APB handshaking, data transfer, and response generation.

### 5️⃣ Top-Level Bridge (`ahb_to_apb_bridge_top`)
Connects all submodules, manages HREADY/HRESP signals, and serves as the interface between AHB and APB buses.

### 6️⃣ APB Slave Model (`apb_slave_model`)
Simple slave model used in simulation to validate the bridge functionality.

---

## 🧪 Testbench

A single **Verilog testbench** (`tb_ahb_to_apb_bridge.v`) is included, which:  
- Generates AHB clock and reset.  
- Performs write transactions to an APB slave.  
- Performs read transactions from an APB slave.  
- Observes HREADY, HRESP, and HRDATA signals.  

---

## 📂 File Structure

/AHB_to_APB_Bridge
├── ahb_req_capture.v
├── byte_en_generator.v
├── addr_decode.v
├── apb_master_ctrl.v
├── ahb_to_apb_bridge_top.v
├── apb_slave_model.v
├── tb_ahb_to_apb_bridge.v
└── README.md

yaml
Copy code

---

## 📝 How to Simulate

1. Open your Verilog simulation tool (ModelSim, Vivado, or any compatible simulator).  
2. Compile all `.v` files in the order:  
ahb_req_capture.v
byte_en_generator.v
addr_decode.v
apb_master_ctrl.v
apb_slave_model.v
ahb_to_apb_bridge_top.v
tb_ahb_to_apb_bridge.v

yaml
Copy code
3. Run the simulation and observe the read/write operations in the waveform viewer.  

---

## 💡 Applications

- Embedded systems requiring AHB-to-APB bridging.  
- Microcontroller peripherals interfacing.  
- FPGA or ASIC IP development.  
- Bus protocol learning and verification exercises.  

---

## ⚡ Performance Highlights

- Fully synchronous with HCLK.  
- Handles multiple APB slaves.  
- Simple FSM ensures minimal latency.  
- Byte-enable support for all standard transfer sizes.  


---

> **Note:** This project is intended for educational, verification, and FPGA prototyping purposes. 
