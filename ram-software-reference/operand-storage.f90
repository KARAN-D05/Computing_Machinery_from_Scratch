! ------------------------------------------------------------
!    Selector pin = 0  ->  Register A
!    Selector pin = 1  ->  Register B
!    Store pin = 0     ->  no latch, data just sitting on lines
!    Store pin = 1     ->  flip-flops latch whatever is on the
!                          data lines into the selected register
!
!  This program shows Register A (Selector = 0).
!  Data sits on the lines first. Nothing is stored yet.
!  When Store goes HIGH, the value is latched into Register A.
! ------------------------------------------------------------
program operand_storage
    implicit none

    integer :: selector   ! 0 = Register A, 1 = Register B
    integer :: store      ! 0 = no latch,   1 = latch
    integer :: data_lines ! value currently sitting on the data lines
    integer :: reg_a      ! Register A - holds latched value

    ! Data is on the lines. Store is LOW. Nothing latched yet.
    selector   = 0
    store      = 0
    data_lines = 9   ! Binary: 1001
    reg_a      = 0   ! Register A is empty

    print *, "============================================"
    print *, " Selector    = ", selector,   "  (Register A)"
    print *, " Store       = ", store,      "  (LOW - no latch)"
    print *, " Data lines  = ", data_lines, "  (sitting on lines)"
    print *, " Register A  = ", reg_a,      "  (empty)"
    print *, "--------------------------------------------"

    ! Store goes HIGH. Flip-flops latch data lines into Register A.
    store = 1
    if (store == 1 .and. selector == 0) reg_a = data_lines

    print *, " Store       = ", store,  "  (HIGH - latch)"
    print *, " Register A  = ", reg_a,  "  (latched)"
    print *, "============================================"

end program operand_storage
