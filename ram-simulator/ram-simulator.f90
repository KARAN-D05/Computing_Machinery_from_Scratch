! ============================================================
!  ram_simulator.f90
! ------------------------------------------------------------
!  Software simulator of the Repeated Arithmetic Machine (RAM)
!  modelled after V3 - Full Autonomous Arithmetic Machine.
!
!  This is a software twin of the physical RAM machine built
!  in Logisim Evolution. Every behaviour here mirrors the
!  actual hardware:
!
!  REGISTERS
!    Register A  -> 4-bit, loaded when Selector = 0
!    Register B  -> 4-bit, loaded when Selector = 1
!    Output      -> 5-bit, can display results up to 31
!
!  PINS
!    Selector pin -> 0 = data to Register A
!                    1 = data to Register B
!    Mode pin     -> 0 = Addition (default)
!                    1 = Subtraction
!    FBK pin      -> routes Output back into Register A
!                    only takes lower 4 bits of Output
!    RSTM         -> clears all registers, output, flags
!    OVRD         -> overrides halt, resumes clock
!
!  OPERATIONS
!    ADD  -> Mode=0, A + B -> Output
!    SUB  -> Mode=1, A - B -> Output, 2s complement auto
!    MUL  -> repeated addition, runs exactly XXXX times
!    DIV  -> repeated subtraction until result = 0
!            if not converged in 10 cycles: error + halt
!    FBK  -> Output -> Register A (lower 4 bits only)
!            halts if Output is 5-bit (overflow + FBK)
!    RSTM -> full machine reset
!    OVRD -> override system halt
!
!  OVERFLOW + FBK RULE
!    Output can go up to 31 with no problem.
!    Halt only triggers when a 5-bit result (> 15) is
!    fed back via FBK. FBK only captures lower 4 bits,
!    so the fed-back value would be corrupted.
!    Machine halts to protect computational integrity.
!
! ------------------------------------------------------------
!  Language  : Fortran 90
!  Models    : RAM V3 - Full Autonomous Arithmetic Machine
!  Project   : Computing Machinery from Scratch
!  Author    : Karan Diwan
!  Date      : 2026
! ============================================================

program ram_simulator

    ! 'implicit none' enforces explicit variable declaration.
    ! Without it Fortran auto-assigns types based on first letter.
    implicit none

    ! --------------------------------------------------------
    ! MACHINE STATE
    ! These variables represent the physical state of the
    ! RAM machine at any given clock cycle.
    ! --------------------------------------------------------

    ! Register A and B: 4-bit registers, valid range 0-15.
    integer :: reg_a
    integer :: reg_b

    ! Output lines: 5-bit, valid range 0-31.
    ! The machine can display results up to 31 without issue.
    integer :: output

    ! Halted flag: mirrors the hardware halt latch.
    ! .true.  = machine is halted, clock disengaged.
    ! .false. = machine running normally.
    ! 'logical' is Fortran's boolean type.
    logical :: halted

    ! Halt reason: stores a message describing why halted.
    ! 'character(len=60)' declares a fixed-length string of 60 chars.
    character(len=60) :: halt_reason

    ! --------------------------------------------------------
    ! INPUT VARIABLES
    ! Used to read user commands and data from the terminal.
    ! --------------------------------------------------------

    ! Command string: holds the operation the user types.
    character(len=10) :: command

    ! Selector: 0 = Register A, 1 = Register B.
    integer :: selector

    ! Data value to load into a register.
    integer :: data

    ! Multiplier for MUL operation (direct XXXX in V3).
    integer :: multiplier

    ! Loop variables for MUL and DIV convergence loops.
    integer :: cycle       ! counts clock cycles
    integer :: max_cycles  ! convergence limit for DIV

    ! Temporary variable for SUB result before storing to output.
    integer :: raw_result

    ! Loop index for uppercase conversion.
    integer :: ci

    ! --------------------------------------------------------
    ! INITIALISE MACHINE STATE
    ! All registers, output and flags start at 0 / false.
    ! This mirrors the machine's power-on / reset state.
    ! --------------------------------------------------------

    reg_a       = 0
    reg_b       = 0
    output      = 0
    halted      = .false.
    halt_reason = ""
    max_cycles  = 10       ! DIV convergence limit (hardware spec)

    ! --------------------------------------------------------
    ! STARTUP BANNER
    ! --------------------------------------------------------

    print *, ""
    print *, "============================================"
    print *, " RAM Machine Simulator - V3"
    print *, " Computing Machinery from Scratch"
    print *, "============================================"
    print *, " Registers   : 4-bit (range 0-15)"
    print *, " Output      : 5-bit (range 0-31)"
    print *, " Halt rule   : overflow + FBK only"
    print *, "--------------------------------------------"
    print *, " Commands:"
    print *, "   LOAD  -> enter selector (0/1) then value"
    print *, "   ADD   -> A + B"
    print *, "   SUB   -> A - B (2s complement auto)"
    print *, "   MUL   -> multiplies B by XXXX (V3 direct)"
    print *, "   DIV   -> divides A by B"
    print *, "   FBK   -> output -> Register A"
    print *, "   OVRD  -> override halt"
    print *, "   RSTM  -> reset machine"
    print *, "   STATE -> print current machine state"
    print *, "   EXIT  -> quit simulator"
    print *, "============================================"
    print *, ""

    ! --------------------------------------------------------
    ! MAIN LOOP
    ! Runs indefinitely until user types EXIT.
    ! Each iteration = one user interaction with the machine.
    ! --------------------------------------------------------

    do

        ! Print current state before each command prompt.
        print *, "--------------------------------------------"
        print *, " A =", reg_a, "  B =", reg_b, &
                 "  Output =", output
        if (halted) then
            ! 'trim()' removes trailing spaces from a string.
            print *, " [HALTED] ", trim(halt_reason)
        end if
        print *, "--------------------------------------------"
        write(*,*) " Enter command: "

        ! 'read(*,*)' reads from standard input (keyboard).
        read(*,*) command

        ! Convert command to uppercase for case-insensitive matching.
        ! Goes character by character through the command string.
        ! 'len_trim()' returns length of string ignoring trailing spaces.
        ! 'iachar()' returns the ASCII integer code of a character.
        ! 'achar()' converts an ASCII integer code back to a character.
        ! Lowercase letters are ASCII 97-122, uppercase are 65-90.
        ! Subtracting 32 converts any lowercase letter to uppercase.
        do ci = 1, len_trim(command)
            if (iachar(command(ci:ci)) >= iachar('a') .and. &
                iachar(command(ci:ci)) <= iachar('z')) then
                command(ci:ci) = achar(iachar(command(ci:ci)) - 32)
            end if
        end do

        ! ====================================================
        ! COMMAND DISPATCH
        ! Each branch handles one machine operation.
        ! 'trim(command)' strips trailing spaces before compare.
        ! ====================================================

        ! ----------------------------------------------------
        ! LOAD
        ! Reads selector and data value from user.
        ! Selector = 0 -> Register A
        ! Selector = 1 -> Register B
        ! ----------------------------------------------------
        if (trim(command) == "LOAD") then

            if (halted) then
                print *, " [ERROR] Machine is halted. Use OVRD or RSTM."

            else
                write(*,*) " Enter selector (0 = Reg A, 1 = Reg B): "
                read(*,*) selector

                ! Validate selector. Only 0 or 1 is valid.
                if (selector /= 0 .and. selector /= 1) then
                    print *, " [ERROR] Invalid selector. Must be 0 or 1."

                else
                    write(*,*) " Enter value (0-15): "
                    read(*,*) data

                    ! Validate data range. Registers are 4-bit (0-15).
                    if (data < 0 .or. data > 15) then
                        print *, " [ERROR] Value out of range. Must be 0-15."

                    else
                        ! Route data to the correct register based on selector.
                        if (selector == 0) then
                            reg_a = data
                            print *, " Loaded ", data, " into Register A."
                        else
                            reg_b = data
                            print *, " Loaded ", data, " into Register B."
                        end if
                    end if
                end if
            end if

        ! ----------------------------------------------------
        ! ADD
        ! Mode pin = 0. Default operation.
        ! A + B -> Output.
        ! Output can reach up to 31. No halt from result alone.
        ! Halt only if this result is then fed back via FBK.
        ! ----------------------------------------------------
        else if (trim(command) == "ADD") then

            if (halted) then
                print *, " [ERROR] Machine is halted. Use OVRD or RSTM."
            else
                output = reg_a + reg_b
                print *, " ADD: ", reg_a, "+", reg_b, "=", output
                if (output > 15) then
                    print *, " Note: result is 5-bit (", output, ")."
                    print *, " Output is fine. Halt only triggers if FBK used."
                end if
            end if

        ! ----------------------------------------------------
        ! SUB
        ! Mode pin = 1. A - B -> Output.
        ! V3: comparator auto-detects B>A condition.
        ! 2s complement applied automatically. No manual pin.
        ! Result can be negative (signed integer).
        ! ----------------------------------------------------
        else if (trim(command) == "SUB") then

            if (halted) then
                print *, " [ERROR] Machine is halted. Use OVRD or RSTM."
            else
                raw_result = reg_a - reg_b
                output = raw_result

                if (reg_b > reg_a) then
                    ! B > A detected automatically by comparator in V3.
                    ! 2s complement correction applied by hardware.
                    print *, " SUB: ", reg_a, "-", reg_b, "=", output
                    print *, " B > A detected by comparator."
                    print *, " 2s complement auto-applied (V3 behaviour)."
                else
                    print *, " SUB: ", reg_a, "-", reg_b, "=", output
                end if
            end if

        ! ----------------------------------------------------
        ! MUL
        ! Repeated addition. Runs exactly XXXX times.
        ! V3 manual mode: direct XXXX multiplication.
        ! (The XXXX-1 rule only applies in V4 machine code
        !  encoding because of how the multiplier bits are
        !  packed into the 16-bit instruction format.)
        ! Multiplicative convergence detector fires at end.
        ! Edge case: multiply by 0 handled.
        ! ----------------------------------------------------
        else if (trim(command) == "MUL") then

            if (halted) then
                print *, " [ERROR] Machine is halted. Use OVRD or RSTM."
            else
                write(*,*) " Enter multiplier (XXXX): "
                read(*,*) multiplier

                if (multiplier < 0) then
                    print *, " [ERROR] Multiplier must be >= 0."

                else if (multiplier == 0) then
                    ! Edge case: multiply by 0.
                    output = 0
                    print *, " MUL: ", reg_b, "x 0 = 0"
                    print *, " Edge case: multiply by zero handled."

                else
                    print *, " MUL: ", reg_b, "x", multiplier
                    print *, " Repeated addition running..."

                    ! Accumulator starts at 0.
                    ! Internally mirrors Register A accumulating each cycle.
                    output = 0

                    ! Run exactly XXXX addition cycles.
                    ! 'do cycle = 1, multiplier' counts from 1 to multiplier.
                    ! Each iteration = one clock cycle on the machine.
                    do cycle = 1, multiplier
                        output = output + reg_b
                        write(*,*) "   Cycle ", cycle, ": ", output
                    end do

                    print *, " Multiplicative Convergence LED -> ON"
                    print *, " Final Product = ", output
                end if
            end if

        ! ----------------------------------------------------
        ! DIV
        ! Repeated subtraction until result = 0.
        ! If result cannot reach 0 in 10 cycles: halt.
        ! Divisibility convergence detector fires when done.
        ! Edge case: divide by 0 -> invalid input halt.
        ! ----------------------------------------------------
        else if (trim(command) == "DIV") then

            if (halted) then
                print *, " [ERROR] Machine is halted. Use OVRD or RSTM."

            else if (reg_b == 0) then
                ! Edge case: divide by zero.
                ! Invalid input detector catches this before processing.
                halted = .true.
                halt_reason = "Division by zero."
                print *, " [HALT] Division by zero detected."
                print *, " Invalid input detector triggered."
                print *, " Use OVRD to override or RSTM to reset."

            else
                print *, " DIV: ", reg_a, "/", reg_b
                print *, " Repeated subtraction running..."

                ! Start from the dividend (Register A value).
                output = reg_a
                cycle  = 0

                ! Subtract reg_b each cycle until output reaches 0.
                ! 'do while (condition)' runs while condition is true.
                do while (output /= 0)
                    cycle = cycle + 1

                    ! Check if convergence limit exceeded.
                    ! Hardware spec: 10 cycle maximum.
                    if (cycle > max_cycles) then
                        halted = .true.
                        halt_reason = "DIV convergence error (>10 cycles)."
                        print *, " [HALT] Convergence error."
                        print *, " Division did not reach 0 in 10 cycles."
                        print *, " Use OVRD to override or RSTM to reset."
                        ! 'exit' breaks out of the innermost do loop.
                        exit
                    end if

                    output = output - reg_b
                    write(*,*) "   Cycle ", cycle, &
                               ": remainder =", output
                end do

                ! Only print final result if machine did not halt.
                ! '.not.' is Fortran's logical NOT operator.
                if (.not. halted) then
                    print *, " Divisibility Convergence LED -> ON"
                    print *, " Quotient  = ", cycle
                    print *, " Remainder = ", output
                    ! Store quotient on output lines for potential FBK.
                    output = cycle
                end if
            end if

        ! ----------------------------------------------------
        ! FBK - Feedback
        ! Routes Output back into Register A.
        ! Only captures lower 4 bits of Output.
        ! If Output > 15: 5-bit result + FBK = HALT.
        ! This is the core halt condition of the machine.
        ! ----------------------------------------------------
        else if (trim(command) == "FBK") then

            if (halted) then
                print *, " [ERROR] Machine is halted. Use OVRD or RSTM."

            else if (output > 15) then
                ! 5-bit result fed back would corrupt computation.
                ! Machine halts to protect architectural integrity.
                halted = .true.
                halt_reason = "Overflow + FBK: 5-bit result fed back."
                print *, " [HALT] Overflow + FBK detected."
                print *, " Output =", output, "(5-bit, > 15)."
                print *, " FBK only takes lower 4 bits."
                print *, " Feeding back would corrupt computation."
                print *, " Machine halted to protect integrity."
                print *, " LEDs ON: Clock Disengaged, System Halted,"
                print *, "          Feedback Overflow."
                print *, " Use OVRD to override or RSTM to reset."

            else
                ! Safe to feed back. Output is within 4-bit range.
                reg_a = output
                print *, " FBK: Output -> Register A =", reg_a
            end if

        ! ----------------------------------------------------
        ! OVRD - Override Halt
        ! Re-engages the clock. Machine resumes.
        ! Computation integrity may be lost if halt was
        ! caused by overflow + FBK.
        ! ----------------------------------------------------
        else if (trim(command) == "OVRD") then

            if (.not. halted) then
                print *, " Machine is not halted. OVRD not needed."
            else
                halted      = .false.
                halt_reason = ""
                print *, " OVRD: Clock re-engaged. Machine resumed."
                print *, " Warning: computation integrity may be lost"
                print *, " if halt was caused by overflow + FBK."
            end if

        ! ----------------------------------------------------
        ! RSTM - Reset Machine
        ! Clears all registers, output and flags to 0.
        ! Clock continues in normal reset state.
        ! ----------------------------------------------------
        else if (trim(command) == "RSTM") then

            reg_a       = 0
            reg_b       = 0
            output      = 0
            halted      = .false.
            halt_reason = ""
            print *, " RSTM: Machine fully reset."
            print *, "   Register A = 0"
            print *, "   Register B = 0"
            print *, "   Output     = 0"
            print *, "   All flags cleared."
            print *, "   Clock continues normally."

        ! ----------------------------------------------------
        ! STATE - Print full machine state
        ! Simulator utility to inspect internal state.
        ! ----------------------------------------------------
        else if (trim(command) == "STATE") then

            print *, " ========== Machine State =========="
            print *, "   Register A  = ", reg_a
            print *, "   Register B  = ", reg_b
            print *, "   Output      = ", output
            if (halted) then
                print *, "   Halted      =  YES"
                print *, "   Halt Reason = ", trim(halt_reason)
            else
                print *, "   Halted      =  NO"
            end if
            print *, " ==================================="

        ! ----------------------------------------------------
        ! EXIT - Quit the simulator
        ! ----------------------------------------------------
        else if (trim(command) == "EXIT") then

            print *, " Simulator stopped."
            ! 'stop' terminates the Fortran program immediately.
            stop

        ! ----------------------------------------------------
        ! UNKNOWN COMMAND
        ! ----------------------------------------------------
        else
            print *, " [ERROR] Unknown command: ", trim(command)
            print *, " Valid: LOAD ADD SUB MUL DIV FBK OVRD RSTM STATE EXIT"
        end if

    end do

end program ram_simulator
