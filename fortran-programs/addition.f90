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
