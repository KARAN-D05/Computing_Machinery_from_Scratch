! ============================================================
!  operand_storage.f90
! ------------------------------------------------------------
!  Hardware Reference Model : Operand Storage System
!  Maps to                  : RAM V0 and all subsequent versions
!  Layer                    : Layer 1 - RAM Hardware
! ------------------------------------------------------------
!  What this models:
!
!  The RAM machine has two input registers: Register A and
!  Register B. Before any arithmetic operation can take place,
!  operands must be loaded into these registers.
!
!  The hardware mechanism works as follows:
!
!    - Data arrives on the 4 data lines (D0 D1 D2 D3)
!    - A Selector pin (S) decides the destination register
!    - A Store pin going HIGH latches the data into the register
!    - The register holds that value until a new STORE occurs
!      or the machine is Reset
!
!  Selector Pin behaviour:
!    S = 0  ->  Data is routed to Register A
!    S = 1  ->  Data is routed to Register B
!
!  Data line bit weights (4-bit, MSB first):
!    D0 = weight 8  (Most Significant Bit)
!    D1 = weight 4
!    D2 = weight 2
!    D3 = weight 1  (Least Significant Bit)
!
!  This is present in RAM V0 and carries through V1, V2, V3, V4.
!  It is the entry point for all operands into the machine.
!
!  This program does NOT model the assembly language layer
!  (asm-v0.x). LOAD-S-XXXX is the assembler mnemonic that
!  sits on top of this hardware behaviour. This program
!  models only the raw hardware: pins, data lines, registers.
! ------------------------------------------------------------
!  Project : Computing Machinery from Scratch
!  File    : operand_storage.f90
!  Author  : Karan Diwan
!  Date    : 2026
! ============================================================

PROGRAM operand_storage

    IMPLICIT NONE

    ! --------------------------------------------------------
    ! Hardware Pin and Register Declarations
    !
    ! These mirror the physical signals in the RAM machine.
    ! Each variable here corresponds to a real pin or line.
    ! --------------------------------------------------------

    ! Selector Pin
    ! S = 0 -> Register A
    ! S = 1 -> Register B
    INTEGER :: S

    ! Store Pin
    ! When STORE goes HIGH (1), data on the lines is latched
    ! into the register selected by S.
    ! In hardware this is the enable signal to the D flip-flops
    ! of the target register.
    INTEGER :: STORE_PIN

    ! Data Lines (4-bit input bus)
    ! These carry the operand bits into the machine.
    ! D0 is MSB (weight 8), D3 is LSB (weight 1).
    INTEGER :: D0, D1, D2, D3

    ! Register A and Register B
    ! 4-bit storage elements. Each holds one operand.
    ! Implemented in hardware as a bank of 4 D flip-flops.
    ! Value persists until a new STORE pulse or a machine RESET.
    INTEGER :: REG_A, REG_B

    ! Decoded decimal value of the current data on the lines.
    ! Computed from the 4 data line bits using their weights:
    !   value = D0*8 + D1*4 + D2*2 + D3*1
    INTEGER :: data_value

    ! --------------------------------------------------------
    ! Initial State
    !
    ! On power-up or after RESET, all registers and lines
    ! are 0. STORE pin is LOW. No data on the lines.
    ! --------------------------------------------------------
    REG_A      = 0
    REG_B      = 0
    D0         = 0
    D1         = 0
    D2         = 0
    D3         = 0
    STORE_PIN  = 0
    S          = 0
    data_value = 0

    WRITE(*,*)
    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,'(A)') "   RAM Hardware Reference : Operand Storage System"
    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,'(A)') "   Models the register routing mechanism present in RAM V0+"
    WRITE(*,'(A)') "   Data lines -> Selector -> Register A or Register B"
    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,*)

    ! --------------------------------------------------------
    ! INITIAL MACHINE STATE
    ! --------------------------------------------------------
    WRITE(*,'(A)') "  [ INITIAL MACHINE STATE ]"
    WRITE(*,'(A)') "  ----------------------------------------------------------"
    WRITE(*,'(A,I1,A,I1,A,I1,A,I1,A)') &
        "   Data Lines   :  D0=", D0, "  D1=", D1, "  D2=", D2, "  D3=", D3, &
        "   (all lines low, no data present)"
    WRITE(*,'(A,I1,A)') "   Selector (S) :  S=", S,  "   (pointing to Register A)"
    WRITE(*,'(A,I1,A)') "   Store Pin    :  STORE=", STORE_PIN, "   (low, latch disabled)"
    WRITE(*,'(A,I2,A)') "   Register A   :  ", REG_A, "   (empty)"
    WRITE(*,'(A,I2,A)') "   Register B   :  ", REG_B, "   (empty)"
    WRITE(*,*)


    ! ==========================================================
    ! OPERATION 1: Store value 9 (binary 1001) into Register A
    !
    ! Hardware sequence:
    !   1. Data lines are driven with the operand bit pattern
    !   2. Selector pin S is driven LOW  ->  targets Register A
    !   3. Store pin is driven HIGH      ->  flip-flops enabled
    !   4. Register A latches the data lines
    !   5. Store pin returns LOW         ->  value locked in REG_A
    ! ==========================================================

    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,'(A)') "   OPERATION 1 : Store operand 9 (binary 1001) -> Register A"
    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,*)

    ! -- Step 1: Drive data lines with the operand --
    !
    ! Value 9 in 4-bit binary is 1001
    !   D0 = 1  (weight 8)
    !   D1 = 0  (weight 4)
    !   D2 = 0  (weight 2)
    !   D3 = 1  (weight 1)
    !   Total = 8 + 0 + 0 + 1 = 9
    !
    ! In hardware: these are physical wires driven HIGH or LOW
    ! by the source circuitry feeding the machine.
    D0 = 1
    D1 = 0
    D2 = 0
    D3 = 1
    data_value = D0*8 + D1*4 + D2*2 + D3*1

    WRITE(*,'(A)') "   Step 1 : Data lines driven with operand bits"
    WRITE(*,'(A,I1,A,I1,A,I1,A,I1)') &
        "            D0=", D0, "  D1=", D1, "  D2=", D2, "  D3=", D3
    WRITE(*,'(A,I2,A)') &
        "            Decoded value = ", data_value, &
        "   ( D0*8 + D1*4 + D2*2 + D3*1  =  8+0+0+1 )"
    WRITE(*,'(A)') &
        "            Lines are stable. Waiting for STORE pulse."
    WRITE(*,*)

    ! -- Step 2: Drive Selector pin LOW --
    !
    ! S = 0 means the multiplexer in front of the register
    ! inputs routes the data lines toward Register A's inputs.
    ! Register B's flip-flop inputs remain disconnected from
    ! the data lines while S is LOW.
    S = 0
    WRITE(*,'(A)') "   Step 2 : Selector pin driven"
    WRITE(*,'(A,I1)') "            S = ", S
    WRITE(*,'(A)') "            Multiplexer output -> Register A inputs"
    WRITE(*,'(A)') "            Register B inputs  -> isolated (not selected)"
    WRITE(*,*)

    ! -- Step 3: Store pin goes HIGH --
    !
    ! STORE = 1 is the clock/enable signal to the D flip-flops
    ! of the selected register. While STORE is HIGH, the
    ! flip-flops are transparent: their Q outputs follow their
    ! D inputs in real time. The D inputs are being driven by
    ! the data lines through the multiplexer.
    STORE_PIN = 1
    WRITE(*,'(A)') "   Step 3 : Store pin driven HIGH"
    WRITE(*,'(A,I1)')  "            STORE = ", STORE_PIN
    WRITE(*,'(A)') "            Register A flip-flops are now transparent"
    WRITE(*,'(A)') "            D inputs (data lines) feeding directly to Q outputs"
    WRITE(*,*)

    ! -- Step 4: Latch event --
    !
    ! The selector gates the STORE enable only to the flip-flops
    ! of Register A. Register B's flip-flops receive no enable
    ! signal regardless of what is on the data lines.
    !
    ! Fortran models this with the IF block below, which directly
    ! mirrors the selector logic in the hardware multiplexer.
    IF (STORE_PIN == 1) THEN
        IF (S == 0) THEN
            REG_A = data_value
            WRITE(*,'(A)') "   Step 4 : Latch event"
            WRITE(*,'(A)') "            S = 0  ->  Register A selected"
            WRITE(*,'(A,I2,A)') &
                "            Register A  <-  ", REG_A, &
                "   (flip-flops now holding this value)"
            WRITE(*,'(A,I2,A)') &
                "            Register B  =   ", REG_B, &
                "   (no enable pulse, remains unchanged)"
        ELSE
            REG_B = data_value
            WRITE(*,'(A)') "   Step 4 : Latch event"
            WRITE(*,'(A)') "            S = 1  ->  Register B selected"
            WRITE(*,'(A,I2,A)') &
                "            Register B  <-  ", REG_B, &
                "   (flip-flops now holding this value)"
            WRITE(*,'(A,I2,A)') &
                "            Register A  =   ", REG_A, &
                "   (no enable pulse, remains unchanged)"
        END IF
    END IF
    WRITE(*,*)

    ! -- Step 5: Store pin returns LOW --
    !
    ! STORE = 0 puts the flip-flops back into hold mode.
    ! The Q outputs are now isolated from the D inputs.
    ! The latched value is stable and locked in the register.
    ! The data lines can now change freely without affecting
    ! the register -- this is the memory behaviour of the
    ! flip-flop bank.
    STORE_PIN = 0
    WRITE(*,'(A)') "   Step 5 : Store pin returns LOW"
    WRITE(*,'(A,I1)')  "            STORE = ", STORE_PIN
    WRITE(*,'(A)') "            Register A flip-flops back in hold mode"
    WRITE(*,'(A)') "            Value is now locked. Data lines can change freely."
    WRITE(*,'(A)') "            Register A will not change until next STORE pulse."
    WRITE(*,*)

    WRITE(*,'(A)') "   [ Register State After Operation 1 ]"
    WRITE(*,'(A,I2)') "   Register A  =  ", REG_A
    WRITE(*,'(A,I2)') "   Register B  =  ", REG_B
    WRITE(*,*)


    ! ==========================================================
    ! OPERATION 2: Store value 3 (binary 0011) into Register B
    !
    ! Identical hardware sequence to Operation 1 except:
    !   - Different bit pattern on the data lines  (0011 = 3)
    !   - Selector pin S is driven HIGH  ->  targets Register B
    !   - Register A is completely isolated, retains its value
    ! ==========================================================

    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,'(A)') "   OPERATION 2 : Store operand 3 (binary 0011) -> Register B"
    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,*)

    ! -- Step 1: Drive data lines with new operand --
    !
    ! Value 3 in 4-bit binary is 0011
    !   D0 = 0  (weight 8)
    !   D1 = 0  (weight 4)
    !   D2 = 1  (weight 2)
    !   D3 = 1  (weight 1)
    !   Total = 0 + 0 + 2 + 1 = 3
    D0 = 0
    D1 = 0
    D2 = 1
    D3 = 1
    data_value = D0*8 + D1*4 + D2*2 + D3*1

    WRITE(*,'(A)') "   Step 1 : Data lines driven with operand bits"
    WRITE(*,'(A,I1,A,I1,A,I1,A,I1)') &
        "            D0=", D0, "  D1=", D1, "  D2=", D2, "  D3=", D3
    WRITE(*,'(A,I2,A)') &
        "            Decoded value = ", data_value, &
        "   ( D0*8 + D1*4 + D2*2 + D3*1  =  0+0+2+1 )"
    WRITE(*,'(A)') &
        "            Lines are stable. Waiting for STORE pulse."
    WRITE(*,*)

    ! -- Step 2: Drive Selector pin HIGH --
    !
    ! S = 1 routes the data lines to Register B's inputs.
    ! Register A's flip-flop inputs are now isolated.
    S = 1
    WRITE(*,'(A)') "   Step 2 : Selector pin driven"
    WRITE(*,'(A,I1)') "            S = ", S
    WRITE(*,'(A)') "            Multiplexer output -> Register B inputs"
    WRITE(*,'(A)') "            Register A inputs  -> isolated (not selected)"
    WRITE(*,*)

    ! -- Step 3: Store pin goes HIGH --
    STORE_PIN = 1
    WRITE(*,'(A)') "   Step 3 : Store pin driven HIGH"
    WRITE(*,'(A,I1)')  "            STORE = ", STORE_PIN
    WRITE(*,'(A)') "            Register B flip-flops are now transparent"
    WRITE(*,'(A)') "            D inputs (data lines) feeding directly to Q outputs"
    WRITE(*,*)

    ! -- Step 4: Latch event --
    !
    ! S = 1 so the enable is gated to Register B's flip-flops.
    ! Register A flip-flops receive no enable and hold their
    ! previously stored value of 9 undisturbed.
    IF (STORE_PIN == 1) THEN
        IF (S == 0) THEN
            REG_A = data_value
            WRITE(*,'(A)') "   Step 4 : Latch event"
            WRITE(*,'(A)') "            S = 0  ->  Register A selected"
            WRITE(*,'(A,I2)') "            Register A  <-  ", REG_A
        ELSE
            REG_B = data_value
            WRITE(*,'(A)') "   Step 4 : Latch event"
            WRITE(*,'(A)') "            S = 1  ->  Register B selected"
            WRITE(*,'(A,I2,A)') &
                "            Register B  <-  ", REG_B, &
                "   (flip-flops now holding this value)"
            WRITE(*,'(A,I2,A)') &
                "            Register A  =   ", REG_A, &
                "   (no enable pulse, still holds 9 from Operation 1)"
        END IF
    END IF
    WRITE(*,*)

    ! -- Step 5: Store pin returns LOW --
    STORE_PIN = 0
    WRITE(*,'(A)') "   Step 5 : Store pin returns LOW"
    WRITE(*,'(A,I1)')  "            STORE = ", STORE_PIN
    WRITE(*,'(A)') "            Register B flip-flops back in hold mode"
    WRITE(*,'(A)') "            Value locked. Both registers now stable."
    WRITE(*,*)

    WRITE(*,'(A)') "   [ Register State After Operation 2 ]"
    WRITE(*,'(A,I2)') "   Register A  =  ", REG_A
    WRITE(*,'(A,I2)') "   Register B  =  ", REG_B
    WRITE(*,*)


    ! ==========================================================
    ! FINAL MACHINE STATE
    !
    ! Both registers now hold their operands and are stable.
    ! The ALU inputs are permanently driven by Register A and
    ! Register B outputs. The arithmetic unit sees:
    !   Input A = 9
    !   Input B = 3
    ! and is ready to perform any operation.
    !
    ! Neither register will change until:
    !   - A new STORE pulse arrives with a new operand, OR
    !   - The machine RESET pin is driven HIGH
    ! ==========================================================

    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,'(A)') "   FINAL MACHINE STATE"
    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,'(A,I2,A)') "   Register A  =  ", REG_A, &
        "   (operand stable on ALU input A)"
    WRITE(*,'(A,I2,A)') "   Register B  =  ", REG_B, &
        "   (operand stable on ALU input B)"
    WRITE(*,*)
    WRITE(*,'(A)') "   Both registers are stable and held by their flip-flop banks."
    WRITE(*,'(A)') "   The arithmetic unit can now operate on A and B."
    WRITE(*,'(A)') "   No further changes will occur until the next STORE pulse"
    WRITE(*,'(A)') "   or until the machine RESET pin is driven HIGH."
    WRITE(*,*)
    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,'(A)') "   Hardware Architecture Note"
    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,'(A)') "   The 4 data lines feed into a multiplexer whose select input"
    WRITE(*,'(A)') "   is driven by the Selector pin S. The multiplexer has two"
    WRITE(*,'(A)') "   output paths:"
    WRITE(*,'(A)') "     Path 0 (S=0)  ->  D inputs of Register A flip-flops"
    WRITE(*,'(A)') "     Path 1 (S=1)  ->  D inputs of Register B flip-flops"
    WRITE(*,'(A)') ""
    WRITE(*,'(A)') "   The STORE pin feeds the enable/clock of both register banks."
    WRITE(*,'(A)') "   However, the selector also gates this enable signal so that"
    WRITE(*,'(A)') "   only the selected register's flip-flops receive the pulse."
    WRITE(*,'(A)') "   The non-selected register is completely isolated and its"
    WRITE(*,'(A)') "   stored value is protected for the entire duration."
    WRITE(*,'(A)') ""
    WRITE(*,'(A)') "   This mechanism is present identically in V0, V1, V2, V3"
    WRITE(*,'(A)') "   and V4. In V4 the STORE pulse is issued by the program"
    WRITE(*,'(A)') "   memory sequencer rather than manually, but the underlying"
    WRITE(*,'(A)') "   register routing hardware is unchanged across all versions."
    WRITE(*,'(A)') "  ============================================================"
    WRITE(*,*)

END PROGRAM operand_storage
