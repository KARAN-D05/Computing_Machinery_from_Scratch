! ============================================================
!  addition.f90
! ------------------------------------------------------------
!  Demonstrates addition the way the RAM hardware does it.
!
!  In the RAM machine:
!    Selector pin = 0 -> data goes into Register A
!    Selector pin = 1 -> data goes into Register B
!    Mode pin     = 0 -> Addition (default operation)
!    Mode pin     = 1 -> Subtraction
!
!  Addition is the DEFAULT operation of the machine.
!  When Mode pin is 0, the ALU adds Register A and
!  Register B and puts the result on the Output pins.
!
!  Output range:
!    Output lines are 5-bit and can display up to 31.
!    No halt occurs from a large result alone.
!    Halt only triggers when a 5-bit result (> 15) is
!    fed back via FBK, because FBK only takes the lower
!    4 bits, which would corrupt the computation.
!
!  Hardware equivalent:
!    LOAD-0-XXXX  -> Selector=0, data -> Register A
!    LOAD-1-XXXX  -> Selector=1, data -> Register B
!    ADD          -> Mode=0, A + B -> Output
! ------------------------------------------------------------

program addition

    implicit none

    ! 'integer' declares whole number variables (no decimals).
    ! These mirror the 4-bit registers in the RAM machine.
    ! Valid range on the machine: 0-15 (4-bit).
    integer :: reg_a   ! Register A - loaded when Selector = 0
    integer :: reg_b   ! Register B - loaded when Selector = 1
    integer :: output  ! Output lines - 5-bit, range 0-31

    ! --------------------------------------------------------
    ! LOAD PHASE
    ! Selector pin decides which register receives the data.
    !   Selector = 0 -> Register A
    !   Selector = 1 -> Register B
    ! Equivalent to LOAD-0-XXXX and LOAD-1-XXXX in asm-v0.
    ! --------------------------------------------------------

    ! '=' is the assignment operator in Fortran.
    ! Selector = 0, so this value goes into Register A.
    reg_a = 9   ! Binary: 1001

    ! Selector = 1, so this value goes into Register B.
    reg_b = 3   ! Binary: 1100

    ! --------------------------------------------------------
    ! ADD OPERATION
    ! Mode pin = 0 -> Addition (the default operation).
    ! The RAM hardware performs this with a 4-bit binary
    ! adder built from logic gates.
    ! Here we use the + operator. Same result, different means.
    ! --------------------------------------------------------

    output = reg_a + reg_b

    print *, "============================================"
    print *, " RAM Machine - Addition"
    print *, "============================================"
    print *, " Selector=0  ->  Register A = ", reg_a
    print *, " Selector=1  ->  Register B = ", reg_b
    print *, " Mode=0      ->  Addition (default)"
    print *, "--------------------------------------------"
    print *, " A + B = ", output
    print *, "============================================"
    print *, " Hardware note:"
    print *, " Output lines are 5-bit (range 0-31)."
    print *, " 9 + 3 = 12, within 4-bit range, no issues."
    print *, " No halt from large output alone."
    print *, " Halt only triggers if a 5-bit result"
    print *, " is then fed back via FBK."
    print *, "============================================"
    
end program addition
