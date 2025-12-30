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
  <img src="docs/images/register.png" width="600"/>
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
  <img src="images/wfcpu.png" width="750"/>
</p>

### 🔹 SoC simulation

<p align="center">
  <img src="images/wfsoc.png" width="750"/>
</p>
