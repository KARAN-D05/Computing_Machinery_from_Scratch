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
!  Hardware equivalent:
!    LOAD-0-XXXX  -> Selector=0, data -> Register A
!    LOAD-1-XXXX  -> Selector=1, data -> Register B
!    ADD          -> Mode=0, A + B -> Output
! ------------------------------------------------------------
!  Language  : Fortran 90
!  Project   : Computing Machinery from Scratch
!  Author    : Karan Diwan
!  Date      : 2026
! ============================================================

! 'program' keyword begins the program block.
! Everything between 'program addition' and 'end program addition'
! is the body of this program.
program addition

    ! 'implicit none' tells Fortran not to guess variable types
    ! automatically. Without it, variables starting with i-n are
    ! auto integers and a-h, o-z are auto reals.
    ! Best practice to always include it.
    implicit none

    ! 'integer' declares whole number variables (no decimals).
    ! These mirror the 4-bit registers in the RAM machine.
    ! Valid range on the machine: 0-15 (4-bit).
    integer :: reg_a   ! Register A - loaded when Selector = 0
    integer :: reg_b   ! Register B - loaded when Selector = 1
    integer :: output  ! Output lines - result of the operation

    ! --------------------------------------------------------
    ! LOAD PHASE
    ! Selector pin decides which register receives the data.
    ! Selector = 0 -> Register A
    ! Selector = 1 -> Register B
    ! Equivalent to LOAD-0-XXXX and LOAD-1-XXXX in asm-v0.
    ! --------------------------------------------------------

    ! '=' is the assignment operator in Fortran.
    ! Selector = 0, so this data goes into Register A.
    reg_a = 9   ! Binary: 1001

    ! Selector = 1, so this data goes into Register B.
    reg_b = 3   ! Binary: 1100

    ! --------------------------------------------------------
    ! ADD OPERATION
    ! Mode pin = 0 -> Addition (the default operation).
    ! The RAM hardware uses a 4-bit binary adder built from
    ! logic gates to perform this. Here we use the + operator.
    ! Both compute the same result through different means.
    ! --------------------------------------------------------

    output = reg_a + reg_b

    ! --------------------------------------------------------
    ! OUTPUT
    ! 'print *,' prints to the terminal.
    ! '*' means use Fortran default formatting.
    ! Text in quotes prints as-is.
    ! Variables after the comma print their value.
    ! --------------------------------------------------------

    print *, "============================================"
    print *, " RAM Machine - Addition"
    print *, "============================================"
    print *, " Selector=0 -> Register A = ", reg_a
    print *, " Selector=1 -> Register B = ", reg_b
    print *, " Mode=0     -> Addition (default)"
    print *, "--------------------------------------------"
    print *, " A + B      = ", output
    print *, "============================================"
    print *, " Hardware note:"
    print *, " RAM output is 4-bit wide (range 0-15)."
    print *, "============================================"

! 'end program' closes the program block.
! Name must match the opening 'program' statement.
end program addition
