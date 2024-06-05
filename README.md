# Digital Systems Architecture Paper

## Overview

This project explores the design, implementation, and testing of various digital system components using VHDL.

## Table of Contents

1. [Introduction](#introduction)
2. [Combinational Circuits](#combinational-circuits)
   - [Multiplexer 16:1](#multiplexer-161)
3. [Sequential Circuits](#sequential-circuits)
   - [Sequence Recognizer](#sequence-recognizer)
   - [Shift Register](#shift-register)
   - [Stopwatch](#stopwatch)
4. [Arithmetic Machines](#arithmetic-machines)
   - [Booth Multiplier](#booth-multiplier)
5. [Communication with Handshaking](#communication-with-handshaking)
6. [IJVM](#ijvm)
7. [Serial Interface](#serial-interface)
8. [Multistage Switch](#multistage-switch)
9. [Appendix](#appendix)
10. [Authors](#authors)
11. [License](#license)

## Introduction

This project encompasses various digital system components and architectures. Each component is meticulously described, including architectural details, VHDL code, and simulation results. The goal is to provide a thorough understanding of digital systems and their practical implementations.

## Combinational Circuits

### Multiplexer 16:1

#### Objective
Design, implement, and test a 16:1 multiplexer using a composition approach with 4:1 multiplexers.

#### Project and Architecture
A multiplexer (mux) is a digital switch that selects one of several input signals and forwards the selected input to a single output line. The 16:1 multiplexer implemented in this project uses a structural approach, combining five 4:1 multiplexers to achieve the desired functionality. This modular approach enhances the design's scalability and readability.

#### Implementation
The implementation involves creating a 4:1 multiplexer using different design approaches (Boolean expressions, WHEN-ELSE constructs, WITH-SELECT constructs) and then combining these to form a 16:1 multiplexer.

#### Simulation
A testbench is used to verify the functionality of the 16:1 multiplexer, simulating various input scenarios to ensure the output matches the expected results.

## Sequential Circuits

### Sequence Recognizer

#### Objective
Design, implement, and test a sequence recognizer that detects a specific binary sequence.

#### Project and Architecture
A sequence recognizer identifies a specific pattern within a stream of input bits. The design involves creating a state machine with states representing the progress through the sequence.

#### Implementation
The sequence recognizer is implemented using VHDL, with a state machine that transitions through states based on input bits.

#### Simulation
A testbench verifies the sequence recognizer by simulating input sequences and checking for correct detection of the target sequence.

### Shift Register

#### Objective
Design, implement, and test a shift register that can shift data in both directions.

#### Project and Architecture
A shift register is a sequential circuit that shifts its data left or right on each clock pulse. It is often used for data storage or transfer.

#### Implementation
The shift register is implemented using VHDL, with options for left and right shifts controlled by input signals.

#### Simulation
A testbench verifies the shift register by simulating shift operations and checking the data integrity.

### Stopwatch

#### Objective
Design, implement, and test a digital stopwatch.

#### Project and Architecture
A digital stopwatch is a sequential circuit that counts clock pulses to measure elapsed time. It typically includes start, stop, and reset functionalities.

#### Implementation
The stopwatch is implemented using VHDL, with counters to track time and control signals for start, stop, and reset operations.

#### Simulation
A testbench verifies the stopwatch by simulating start, stop, and reset operations and checking the time counting accuracy.

## Arithmetic Machines

### Booth Multiplier

#### Objective
Design, implement, and test a Booth multiplier for efficient binary multiplication.

#### Project and Architecture
Booth's algorithm is an efficient method for multiplying binary numbers. It reduces the number of necessary arithmetic operations by encoding the multiplication process.

#### Implementation
The Booth multiplier is implemented using VHDL, with an algorithm that iterates through bits of the multiplier to perform partial product additions and shifts.

#### Simulation
A testbench verifies the Booth multiplier by simulating various multiplication operations and checking the product results.

## Communication with Handshaking

#### Objective
Design, implement, and test a communication system using handshaking protocols.

#### Project and Architecture
Handshaking protocols are used in digital communication to ensure data integrity and synchronization between sender and receiver.

#### Implementation
The communication system is implemented using VHDL, with signals for request, acknowledge, and data transfer between sender and receiver.

#### Simulation
A testbench verifies the communication system by simulating data transfers and checking for correct synchronization and data integrity.

## IJVM

#### Objective
Design, implement, and test an IJVM (Integer Java Virtual Machine) to execute Java bytecode.

#### Project and Architecture
IJVM is a simplified Java Virtual Machine that executes a subset of Java bytecode instructions. It includes components like the instruction fetch unit, decode unit, and execution unit.

#### Implementation
The IJVM is implemented using VHDL, with components to fetch, decode, and execute Java bytecode instructions.

#### Simulation
A testbench verifies the IJVM by simulating the execution of Java bytecode programs and checking for correct instruction execution and program behavior.

## Serial Interface

#### Objective
Design, implement, and test a serial interface for communication.

#### Project and Architecture
A serial interface allows digital systems to communicate over a single data line, typically using protocols like UART (Universal Asynchronous Receiver/Transmitter).

#### Implementation
The serial interface is implemented using VHDL, with components for serial data transmission and reception.

#### Simulation
A testbench verifies the serial interface by simulating data transmission and reception operations and checking for correct data handling.

## Multistage Switch

#### Objective
Design, implement, and test a multistage switch for network routing.

#### Project and Architecture
A multistage switch routes data packets through multiple stages of switching elements, providing scalable and efficient network communication.

#### Implementation
The multistage switch is implemented using VHDL, with stages of switching elements that route data based on input control signals.

#### Simulation
A testbench verifies the multistage switch by simulating data routing operations and checking for correct packet delivery and routing efficiency.

## Appendix

The appendix contains additional details, including VHDL code snippets, simulation results, and explanations of design choices.

## Authors
- [Leonardo Catello](https://github.com/Leonard2310) 
- [Lorenzo Manco](https://github.com/Rasbon99) 
- [Ilaria Saulino](https://github.com/ilaria-xx)

## License
This project is licensed under the [GNU General Public License v3.0]. Refer to the LICENSE file for more information.

<img src="https://raw.githubusercontent.com/Rasbon99/VHDLProjects/main/assets/logo.png" alt="drawing" width="70"/> powered by ElevenMeatballs.

