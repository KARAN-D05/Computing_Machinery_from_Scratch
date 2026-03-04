! ============================================================
!  operand_storage.f90
!  Hardware Reference Model : Operand Storage System
!  RAM V0+  |  Layer 1 - Hardware
! ------------------------------------------------------------
!  The machine has two input registers: A and B.
!  Data arrives on 4 lines. The Selector pin decides
!  which register latches it when STORE goes HIGH.
!
!  S = 0  ->  Register A
!  S = 1  ->  Register B
!
!  Data line weights: D0=8, D1=4, D2=2, D3=1  (MSB first)
! ============================================================

PROGRAM operand_storage

    IMPLICIT NONE

    INTEGER :: S               ! Selector pin.  0 -> Reg A | 1 -> Reg B
    INTEGER :: STORE_PIN       ! Flip-flop enable. HIGH latches data lines into selected register.
    INTEGER :: D0, D1, D2, D3  ! 4-bit data bus. D0 is MSB (weight 8).
    INTEGER :: REG_A, REG_B    ! Register banks. Hold value until next STORE or RESET.
    INTEGER :: data_value

    ! -- Initial state: power-up / post-reset --
    REG_A = 0 ; REG_B = 0
    D0 = 0 ; D1 = 0 ; D2 = 0 ; D3 = 0
    S = 0 ; STORE_PIN = 0

    WRITE(*,'(A,I1,A,I1,A,I1,A,I1)') "  Initial   | D0=",D0," D1=",D1," D2=",D2," D3=",D3
    WRITE(*,'(A,I2,A,I2)')            "             | REG_A=",REG_A,"  REG_B=",REG_B
    WRITE(*,*)


    ! ==========================================================
    !  STORE 9 (1001) -> Register A
    ! ==========================================================

    ! Drive data lines: 1001 = 8+0+0+1 = 9
    D0=1 ; D1=0 ; D2=0 ; D3=1
    data_value = D0*8 + D1*4 + D2*2 + D3*1

    S = 0           ! Selector LOW  -> multiplexer routes to Register A
    STORE_PIN = 1   ! Enable HIGH   -> Register A flip-flops transparent, latching data lines

    IF (STORE_PIN == 1) THEN
        IF (S == 0) THEN
            REG_A = data_value  ! Data lines latched into REG_A
        ELSE
            REG_B = data_value
        END IF
    END IF

    STORE_PIN = 0   ! Enable LOW -> flip-flops back in hold mode, value locked

    WRITE(*,'(A,I1,A,I1,A,I1,A,I1,A,I2)') &
        "  STORE A  | D0=",D0," D1=",D1," D2=",D2," D3=",D3,"  value=",data_value
    WRITE(*,'(A,I1,A)')    "  S=",S,"  ->  Register A selected"
    WRITE(*,'(A,I2,A,I2)') "  After    | REG_A=",REG_A,"  REG_B=",REG_B
    WRITE(*,*)


    ! ==========================================================
    !  STORE 3 (0011) -> Register B
    !  Register A untouched -- its flip-flops receive no enable.
    ! ==========================================================

    ! Drive data lines: 0011 = 0+0+2+1 = 3
    D0=0 ; D1=0 ; D2=1 ; D3=1
    data_value = D0*8 + D1*4 + D2*2 + D3*1

    S = 1           ! Selector HIGH -> multiplexer routes to Register B
    STORE_PIN = 1   ! Enable HIGH   -> Register B flip-flops transparent, latching data lines

    IF (STORE_PIN == 1) THEN
        IF (S == 0) THEN
            REG_A = data_value
        ELSE
            REG_B = data_value  ! Data lines latched into REG_B. REG_A isolated, unchanged.
        END IF
    END IF

    STORE_PIN = 0   ! Enable LOW -> flip-flops back in hold mode, value locked

    WRITE(*,'(A,I1,A,I1,A,I1,A,I1,A,I2)') &
        "  STORE B  | D0=",D0," D1=",D1," D2=",D2," D3=",D3,"  value=",data_value
    WRITE(*,'(A,I1,A)')    "  S=",S,"  ->  Register B selected"
    WRITE(*,'(A,I2,A,I2)') "  After    | REG_A=",REG_A,"  REG_B=",REG_B
    WRITE(*,*)


    ! ==========================================================
    !  Final state: both registers stable, ALU inputs ready
    ! ==========================================================

    WRITE(*,'(A)')    "  ----------------------------------------"
    WRITE(*,'(A,I2)') "  REG_A  =  ", REG_A
    WRITE(*,'(A,I2)') "  REG_B  =  ", REG_B
    WRITE(*,'(A)')    "  Machine ready for arithmetic."
    WRITE(*,'(A)')    "  ----------------------------------------"

END PROGRAM operand_storage
