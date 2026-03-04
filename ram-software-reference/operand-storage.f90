! ------------------------------------------------------------
!  The RAM machine has two input registers: A and B.
!  Before any arithmetic operation, operands must be stored.
!
!  Hardware mechanism:
!    - 4 data lines carry the operand (D0=MSB, D3=LSB)
!    - Selector pin S routes data to Register A or B
!    - Store pin going HIGH latches data into the register
!    - Register holds value until next STORE or RESET
!
!  S = 0  ->  Register A
!  S = 1  ->  Register B
!
!  Bit weights: D0=8, D1=4, D2=2, D3=1
! ------------------------------------------------------------

PROGRAM operand_storage

    IMPLICIT NONE

    ! Hardware pins
    INTEGER :: S            ! Selector pin: 0 = Reg A, 1 = Reg B
    INTEGER :: STORE_PIN    ! Store pin: HIGH latches data into selected register

    ! 4-bit data lines (D0 = MSB weight 8, D3 = LSB weight 1)
    INTEGER :: D0, D1, D2, D3

    ! Registers (4-bit D flip-flop banks)
    INTEGER :: REG_A, REG_B

    ! Decoded value of current data lines
    INTEGER :: data_value

    ! --------------------------------------------------------
    ! Initial state — power up / post RESET
    ! --------------------------------------------------------
    REG_A = 0 ;  REG_B = 0
    D0 = 0 ;  D1 = 0 ;  D2 = 0 ;  D3 = 0
    S = 0 ;  STORE_PIN = 0
    data_value = 0

    PRINT *, ""
    PRINT *, "============================================================"
    PRINT *, " RAM Hardware Reference : Operand Storage System"
    PRINT *, "============================================================"
    PRINT *, " S=0 -> Register A  |  S=1 -> Register B"
    PRINT *, " STORE HIGH -> latch data lines into selected register"
    PRINT *, "============================================================"
    PRINT *, ""
    PRINT *, " [ Initial State ]"
    PRINT '(A,I1,A,I1,A,I1,A,I1)', "   Data Lines : D0=",D0," D1=",D1," D2=",D2," D3=",D3
    PRINT '(A,I1)',                 "   S          : ", S
    PRINT '(A,I1)',                 "   STORE      : ", STORE_PIN
    PRINT '(A,I2)',                 "   Register A : ", REG_A
    PRINT '(A,I2)',                 "   Register B : ", REG_B
    PRINT *, ""


    ! ==========================================================
    ! STORE 9 (1001) -> Register A
    ! D0=1 D1=0 D2=0 D3=1  ->  8+0+0+1 = 9
    ! S=0 routes to Register A
    ! ==========================================================

    PRINT *, "------------------------------------------------------------"
    PRINT *, " Store 9 (1001) -> Register A"
    PRINT *, "------------------------------------------------------------"

    ! Drive data lines
    D0 = 1 ;  D1 = 0 ;  D2 = 0 ;  D3 = 1
    data_value = D0*8 + D1*4 + D2*2 + D3*1

    PRINT '(A,I1,A,I1,A,I1,A,I1,A,I2)', &
        "   Data Lines : D0=",D0," D1=",D1," D2=",D2," D3=",D3,"  ->  value =",data_value

    ! Selector points to Register A
    S = 0
    PRINT '(A,I1,A)', "   S          : ", S, "  (Register A selected)"

    ! STORE HIGH — flip-flops of Register A are now transparent
    STORE_PIN = 1
    PRINT '(A,I1,A)', "   STORE      : ", STORE_PIN, "  (Register A flip-flops enabled)"

    ! Latch — selector gates enable to Register A only, Register B isolated
    IF (STORE_PIN == 1) THEN
        IF (S == 0) THEN
            REG_A = data_value
        ELSE
            REG_B = data_value
        END IF
    END IF

    PRINT '(A,I2,A)', "   Register A : ", REG_A, "  (latched)"
    PRINT '(A,I2,A)', "   Register B : ", REG_B, "  (isolated, unchanged)"

    ! STORE returns LOW — flip-flops back in hold mode, value locked
    STORE_PIN = 0
    PRINT '(A,I1,A)', "   STORE      : ", STORE_PIN, "  (hold mode, value locked)"
    PRINT *, ""


    ! ==========================================================
    ! STORE 3 (0011) -> Register B
    ! D0=0 D1=0 D2=1 D3=1  ->  0+0+2+1 = 3
    ! S=1 routes to Register B
    ! ==========================================================

    PRINT *, "------------------------------------------------------------"
    PRINT *, " Store 3 (0011) -> Register B"
    PRINT *, "------------------------------------------------------------"

    ! Drive data lines
    D0 = 0 ;  D1 = 0 ;  D2 = 1 ;  D3 = 1
    data_value = D0*8 + D1*4 + D2*2 + D3*1

    PRINT '(A,I1,A,I1,A,I1,A,I1,A,I2)', &
        "   Data Lines : D0=",D0," D1=",D1," D2=",D2," D3=",D3,"  ->  value =",data_value

    ! Selector points to Register B
    S = 1
    PRINT '(A,I1,A)', "   S          : ", S, "  (Register B selected)"

    ! STORE HIGH — flip-flops of Register B enabled, Register A isolated
    STORE_PIN = 1
    PRINT '(A,I1,A)', "   STORE      : ", STORE_PIN, "  (Register B flip-flops enabled)"

    IF (STORE_PIN == 1) THEN
        IF (S == 0) THEN
            REG_A = data_value
        ELSE
            REG_B = data_value
        END IF
    END IF

    PRINT '(A,I2,A)', "   Register A : ", REG_A, "  (isolated, still holds 9)"
    PRINT '(A,I2,A)', "   Register B : ", REG_B, "  (latched)"

    STORE_PIN = 0
    PRINT '(A,I1,A)', "   STORE      : ", STORE_PIN, "  (hold mode, value locked)"
    PRINT *, ""


    ! ==========================================================
    ! Final machine state
    ! Both registers stable. ALU inputs are live.
    ! No change until next STORE pulse or RESET.
    ! ==========================================================

    PRINT *, "============================================================"
    PRINT *, " Final Machine State"
    PRINT *, "============================================================"
    PRINT '(A,I2)', "   Register A  =  ", REG_A
    PRINT '(A,I2)', "   Register B  =  ", REG_B
    PRINT *, ""
    PRINT *, " Both registers stable. ALU inputs are live."
    PRINT *, " Machine ready for arithmetic operation."
    PRINT *, "============================================================"
    PRINT *, ""

END PROGRAM operand_storage
