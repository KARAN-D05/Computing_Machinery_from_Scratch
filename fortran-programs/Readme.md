# 🔬 Fortran

The same computations the RAM machine performs in hardware, expressed in Fortran 90 - the language built in 1957 specifically for this kind of numerical computing.

## Why Fortran?

Fortran (Formula Translation, 1957) was the first high-level language designed to express exactly the kind of arithmetic this machine performs in hardware. The connection is direct - the same operations the RAM executes in logic gates, Fortran describes in human-readable code.

This extends the computing stack built in this project:
```
Logic Gates       ← built from scratch in Logisim
RAM Hardware      ← the machine itself (V0 → V4)
Machine Code      ← 16-bit instruction format (V4)
Assembly Language ← asm-v0 (Assembler repo)
Fortran           ← this folder
```

## Programs

| File | Demonstrates | Hardware equivalent |
|---|---|---|
| `addition.f90` | Default ADD operation | Selector pin, Mode=0, A+B |
| `subtraction.f90` | SUB with positive and negative results | Mode=1, 2s complement evolution V0→V3 |

More programs will be added as the machine documentation is completed.

## How to Compile and Run

Requires `gfortran` (part of GCC).

**Linux / Mac:**
```bash
sudo apt install gfortran    # Ubuntu/Debian
brew install gcc             # macOS

gfortran addition.f90 -o addition
./addition

gfortran subtraction.f90 -o subtraction
./subtraction
```

**Windows (WSL):**
```bash
sudo apt install gfortran
gfortran addition.f90 -o addition
./addition
```

**Windows (Powershell):**
```Powershell
gfortran addition.f90 -o addition
./addition
```
