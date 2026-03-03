! ============================================================
!  subtraction.f90
! ------------------------------------------------------------
!  Demonstrates subtraction the way the RAM hardware does it.
!
!  In the RAM machine:
!    Selector pin = 0 -> data goes into Register A
!    Selector pin = 1 -> data goes into Register B
!    Mode pin     = 0 -> Addition (default)
!    Mode pin     = 1 -> Subtraction
!
!  Setting Mode pin = 1 switches the ALU to subtraction mode.
!  If the result goes negative, the machine uses 2s complement.
!
!  Evolution across RAM versions:
!    V0 -> errors if result goes below 0
!    V1 -> manual B>A pin required for 2s complement
!    V2 -> comparator auto-detects B>A condition
!    V3 -> fully automated signed result handling
!
!  This program demonstrates both cases:
!    Case 1: A > B, positive result
!    Case 2: B > A, negative result (2s complement)
!
!  Hardware equivalent:
!    LOAD-0-XXXX  -> Selector=0, data -> Register A
!    LOAD-1-XXXX  -> Selector=1, data -> Register B
!    SUB          -> Mode=1, A - B -> Output
! ------------------------------------------------------------
!  Language  : Fortran 90
!  Project   : Computing Machinery from Scratch
!  Author    : Karan Diwan
!  Date      : 2026
! ============================================================

program subtraction

    ! 'implicit none' enforces explicit variable declaration.
    implicit none

    ! Declare integer variables mirroring the RAM registers.
    integer :: reg_a   ! Register A - loaded when Selector = 0
    integer :: reg_b   ! Register B - loaded when Selector = 1
    integer :: output  ! Output lines - result of the operation

    ! --------------------------------------------------------
    ! CASE 1: A > B (positive result, no 2s complement needed)
    ! All RAM versions handle this correctly.
    ! --------------------------------------------------------

    ! Selector = 0 -> data goes into Register A.
    reg_a = 14   ! Binary: 1110

    ! Selector = 1 -> data goes into Register B.
    reg_b = 6    ! Binary: 0110

    ! Mode = 1 -> Subtraction.
    ! In hardware, subtraction is done by computing the
    ! 2s complement of B and feeding it into the same
    ! adder circuit used for addition.
    output = reg_a - reg_b

    print *, "============================================"
    print *, " RAM Machine - Subtraction"
    print *, "============================================"
    print *, " CASE 1: A > B (Positive Result)"
    print *, "--------------------------------------------"
    print *, " Selector=0 -> Register A = ", reg_a
    print *, " Selector=1 -> Register B = ", reg_b
    print *, " Mode=1     -> Subtraction"
    print *, " A - B      = ", output
    print *, " Result is positive. No correction needed."
    print *, "--------------------------------------------"

    ! --------------------------------------------------------
    ! CASE 2: B > A (negative result, 2s complement applies)
    ! V1: programmer manually sets the B>A pin before SUB.
    ! V2: comparator detects B>A automatically.
    ! V3: fully automated, no intervention needed.
    ! --------------------------------------------------------

    ! Fortran allows reassigning variables at any point.
    ! Selector = 0 -> Register A.
    reg_a = 3    ! Binary: 0011

    ! Selector = 1 -> Register B.
    reg_b = 9    ! Binary: 1001

    ! Mode = 1 -> Subtraction. B > A here, result is negative.
    output = reg_a - reg_b

    print *, " CASE 2: B > A (Negative Result)"
    print *, "--------------------------------------------"
    print *, " Selector=0 -> Register A = ", reg_a
    print *, " Selector=1 -> Register B = ", reg_b
    print *, " Mode=1     -> Subtraction"
    print *, " A - B      = ", output
    print *, " Result is negative."
    print *, " V1: manual B>A pin required before SUB."
    print *, " V2+: comparator auto-detects B>A."
    print *, "============================================"
    print *, " Hardware note:"
    print *, " Fortran handles negatives natively using"
    print *, " signed integer representation in the CPU."
    print *, " The RAM machine achieves the same result"
    print *, " using 2s complement logic gate circuits."
    print *, "============================================"

end program subtraction
