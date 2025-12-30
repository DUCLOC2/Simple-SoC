## 📌 Overview

This project implements a **simple SoC based on a MIPS CPU** with the following characteristics:

- Basic Integer Instructions  
- Unsigned operations only  
- Harvard architecture  
- Software development using **ASM + MARS**

### SoC Components
- MIPS CPU  
- ROM (Instruction Memory)  
- RAM (Data Memory)  
- Simple System Bus  
- GPIO  
- PWM  

---

## 1️⃣ Instruction Set Architecture (ISA)

The CPU supports a subset of basic MIPS integer instructions, organized into three instruction formats.

### 🔹 R-Type Instruction Format
<p align="center">
  <img src="images/r_type.png" width="600"/>
</p>

### 🔹 I-Type Instruction Format
<p align="center">
  <img src="images/i_type.png" width="600"/>
</p>

### 🔹 J-Type Instruction Format
<p align="center">
  <img src="images/j_type.png" width="600"/>
</p>

---

## 2️⃣ Register File

The CPU contains a **general-purpose register file** used for arithmetic, logic, and data transfer operations.

<p align="center">
  <img src="images/register.png" width="600"/>
</p>

---

## 3️⃣ CPU Architecture

The internal architecture of the MIPS CPU includes:
- Instruction Fetch  
- Decode  
- Execute  
- Memory Access  
- Write Back  

<p align="center">
  <img src="images/cpu.png" width="700"/>
</p>

---

## 4️⃣ Control Unit

The Control Unit decodes instructions and generates control signals for:
- ALU  
- Register File  
- Memory  
- Program Counter  

<p align="center">
  <img src="images/control.png" width="650"/>
</p>

---

## 5️⃣ System Bus

A simple system bus is used to connect:
- CPU  
- ROM  
- RAM  
- Peripherals (GPIO, PWM)  

<p align="center">
  <img src="images/systembus.png" width="650"/>
</p>

---

## 6️⃣ Simple SoC Architecture

The complete SoC integration including CPU, memory, and peripherals is shown below.

<p align="center">
  <img src="images/simplesoc.png" width="750"/>
</p>

---

## 7️⃣ Software Flow

Software is developed using:
- MIPS Assembly Language  
- MARS Simulator  

<p align="center">
  <img src="images/software.png" width="650"/>
</p>

## 8️⃣ Results


### 🔹 CPU simulation

<p align="center">
  <img src="images/wf_cpu.png" width="750"/>
</p>

### 🔹 SoC simulation

<p align="center">
  <img src="images/wf_soc.png" width="750"/>
</p>

## 9️⃣ Post-Implementation Analysis: Area, Power, and Timing

### 🔹 Area Report


<p align="center">
  <img src="images/rp_area.png" width="750"/>
</p>

### 🔹 Power Report

<p align="center">
  <img src="images/power.png" width="750"/>
</p>

### 🔹 Timing Report

<p align="center">
  <img src="images/constraint.png" width="750"/>
</p>
<p align="center">
  <img src="images/fmax.png" width="750"/>
</p>
<p align="center">
  <img src="images/setup.png" width="750"/>
</p>
<p align="center">
  <img src="images/hold.png" width="750"/>
</p>

**Timing Analysis Remarks:**

The CPU is implemented using a **single-cycle architecture**, in which all instruction stages (fetch, decode, execute, memory access, and write-back) are completed within one clock cycle.  
As a result, the **critical path is relatively long**, limiting the maximum achievable clock frequency.

The timing analysis reports a **maximum operating frequency (Fmax) of 50.34 MHz**, which indicates that the design is **not frequency-optimized** compared to multi-cycle or pipelined architectures.

With the clock constraint set to **50 MHz**, both **setup slack and hold slack are positive**, confirming that:
- All setup timing requirements are satisfied  
- No hold time violations are detected  
- The design operates **correctly and reliably** under the specified timing constraint  

Overall, the timing results demonstrate that the single-cycle CPU meets the target clock frequency and functions correctly from a timing perspective.
