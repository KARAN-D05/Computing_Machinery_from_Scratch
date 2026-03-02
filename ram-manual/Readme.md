# ram-manual

A built-in reference manual for the Repeated Arithmetic
Machine project. Query the full machine architecture,
components and version history directly from your terminal.

---

## Run on Linux / Mac (Bash)

**Step 1 - Download the script**
```bash
curl -O https://raw.githubusercontent.com/KARAN-D05/Computing_Machinery_from_Scratch/main/ram-manual/run-ram-manual.sh
```

**Step 2 - Give it permission to execute**
```bash
chmod +x run-ram-manual.sh
```

**Step 3 - Run it**
```bash
./run-ram-manual.sh
```

---

## Run on Windows (PowerShell)

**Step 1 - Download the script**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KARAN-D05/Computing_Machinery_from_Scratch/main/ram-manual/run-ram-manual.ps1" -OutFile "run-ram-manual.ps1"
```

**Step 2 - Run it**
```powershell
powershell -ExecutionPolicy Bypass -File run-ram-manual.ps1
```

---

## Requirements

GCC must be installed. Check if you have it:
```
gcc --version
```

If not installed:

| OS            | Command / Link                                            |
|---------------|-----------------------------------------------------------|
| Ubuntu/Debian | `sudo apt install gcc`                                    |
| Mac           | `xcode-select --install`                                  |
| Windows       | https://www.mingw-w64.org then add `C:\MinGW\bin` to PATH |

---

## After First Run

Once compiled you do not need the script again.
Just run the binary directly:

**Linux / Mac:**
```bash
./ram-manual
```

**Windows:**
```powershell
.\ram-manual.exe
```

---

## Usage

Once the program is running, type the version you want:

| Command | Description                                       |
|---------|---------------------------------------------------|
| V0      | Proof of concept, ADD + SUB, no error handling    |
| V1      | 2s complement, manual B>A correction              |
| V2      | Auto B>A detection, automated correction          |
| V3      | Full autonomous machine, 400+ logic gates         |
| V4      | Stored program architecture, 16-bit instructions  |
| all     | Show all versions at once                         |
| search  | Search for a specific component or term           |
| exit    | Quit the program                                  |

You can also search directly from the terminal:
```bash
./ram-manual --search overflow
./ram-manual --search feedback
./ram-manual --search instruction
```

---

## Files

| File                  | Description                        |
|-----------------------|------------------------------------|
| `ram-manual.c`        | Source code of the manual          |
| `run-ram-manual.sh`   | Bash script for Linux / Mac        |
| `run-ram-manual.ps1`  | PowerShell script for Windows      |

---

*Part of the Computing Machinery from Scratch project by KARAN-D05*
