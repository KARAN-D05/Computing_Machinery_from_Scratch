# ram-software-reference

**Software Reference Models for the RAM Hardware**

---

## What is this?

This folder contains a set of Fortran programs that model the hardware behaviour of the **Repeated Arithmetic Machine (RAM)** — a computing machine built from scratch using logic gates.

Each program in this folder isolates one specific hardware mechanism and models exactly what that mechanism does: which pins are involved, what happens when a pin goes HIGH or LOW, how data moves through the machine, and what state the machine ends up in. The programs are not simulations of the full machine running — they are focused, readable, one-concept-at-a-time references.

---

## Why does this exist?

The RAM project is documented at the hardware level — circuit files, gate diagrams, control logic, flip-flop behaviour. That documentation is complete and precise, but it requires familiarity with digital logic to read.

This reference exists for a different audience: people who understand code and programs but are not familiar with gates, flip-flops, multiplexers, or control signals. For that reader, a Fortran program that declares `SELECTOR_PIN`, drives it HIGH or LOW, and shows what happens to the registers is a more natural entry point than a circuit diagram.

The goal is not to replace the hardware documentation. It is to give a second angle on the same system - one that speaks in the language of variables, conditionals, and program flow rather than the language of gates and wires.

---

## Why Fortran?

Fortran is a natural fit for this kind of work for several reasons.

It is old. Fortran was the language of early scientific and engineering computation - the era this machine's architecture is inspired by. Using Fortran to describe the behaviour of a machine that models early computing principles creates a coherent historical alignment between the reference language and the subject matter.

It is explicit. Fortran has no magic. There is no abstraction hiding what is happening. Variables are declared. Types are explicit. Every operation is visible. This matches the spirit of the hardware - the RAM machine was built from first principles with no shortcuts, and Fortran models it with the same directness.

It is readable as pseudocode. Even someone who has never written Fortran can read `IF (S == 0) THEN REG_A = data_value` and understand exactly what it means. The programs in this folder are written to be read, not just compiled. The code is the documentation.

It has no standard library to hide behind. There are no collections, no hash maps, no abstractions that obscure the underlying logic. Everything that happens is written out explicitly, which is exactly what a hardware reference model needs.

---

## How to read these programs

Each program follows the same structure:

1. **Header comment** - explains which hardware mechanism is being modelled, which RAM version it applies to, and what the program does and does not cover.
2. **Variable declarations** - each variable corresponds to a real hardware pin, line, or register. The comments explain what the physical signal is.
3. **Initial state** - the machine state at power-up or after RESET. All registers zero, all pins LOW.
4. **Operations** - each operation is broken into steps that mirror the hardware sequence. Comments explain what is physically happening at each step.
5. **Final state** - the machine state after all operations complete, with a hardware architecture note explaining the underlying mechanism.

These programs are meant to be read top to bottom like a walkthrough. Running them produces output that narrates the same sequence the hardware performs.

---

## How to compile and run

Any modern Fortran compiler works. Using `gfortran`:

```bash
gfortran operand_storage.f90 -o operand_storage
./operand_storage
```

---

## Relationship to the rest of the stack

The RAM project has two layers:

- **Layer 1 - Hardware**: The RAM machine itself, implemented in Logisim Evolution. V0 through V4.
- **Layer 2 - Software**: The Assembly Language (asm-v0.1 through asm-v0.3) built on top of the machine code.

The programs in this folder model **Layer 1 only** - the raw hardware behaviour. They do not model the assembly language layer. The LOAD-S-XXXX mnemonic, for example, is an assembler construct that sits on top of the hardware store mechanism. The Fortran program `operand_storage.f90` models what the hardware is actually doing when that instruction executes - it does not model the assembler itself.

This distinction matters. The assembler is an abstraction. This reference strips that abstraction away and shows the pins, the lines, and the registers directly.

---

## Program Index

| File | Hardware Mechanism | RAM Version |
|---|---|---|
| `operand_storage.f90` | Operand storage system — selector pin routes data to Register A or Register B | V0+ |

*More programs will be added as each hardware mechanism is covered.*
