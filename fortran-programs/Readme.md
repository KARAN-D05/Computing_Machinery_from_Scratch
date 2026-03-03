# 🔬 Fortran Programs

These programs demonstrate the core computations of the **Repeated Arithmetic Machine (RAM)** expressed in Fortran 90.

## Why Fortran?

Fortran (Formula Translation, 1957) was the first high-level language designed to express exactly the kind of numerical computations this machine performs in hardware. The connection is direct - the same operations the RAM machine executes in logic gates, Fortran describes in human-readable code.

This completes the computing stack built in this project:
```
Logic Gates          ← built from scratch in Logisim
RAM Hardware         ← the machine itself (V0 → V4)
Machine Code         ← 16-bit instruction format (V4)
Assembly Language    ← asm-v0 (Assembler repo)
Fortran              ← this folder
```

Each Fortran program traces the same algorithm the hardware runs, with comments linking every step back to the RAM circuit behaviour.

## Programs

| File | Demonstrates | Hardware Equivalent |
|---|---|---|
| `addition.f90` | Default ADD operation | Selector=0, A+B |
| `subtraction.f90` | SUB with both positive and negative results | Selector=1, 2s complement |
| `multiplication.f90` | Repeated addition loop mirroring MUL | MUL-XXXX, convergence detector |
| `division.f90` | Repeated subtraction loop mirroring DIV | DIV, divisibility convergence |
| `feedback.f90` | FBK chain — output fed back as next input | FBK, chained operations |

## How to Compile and Run

Requires `gfortran` (part of GCC).

**Linux / Mac:**
```bash
# Install gfortran if not present
sudo apt install gfortran       # Debian/Ubuntu
brew install gcc                # macOS

# Compile
gfortran addition.f90 -o addition

# Run
./addition
```

**Windows:**
```powershell
# Install via MinGW or WSL, then:
gfortran addition.f90 -o addition.exe
.\addition.exe
```

Replace `addition` with any program name to run the others.

## Connection to asm-v0 Sample Programs

The feedback chain in `feedback.f90` directly mirrors **P2** from the asm-v0 sample programs. The division trace in `division.f90` shows the same intermediate convergence cycles as **P3**. The multiplication trace matches **P4**.
```
