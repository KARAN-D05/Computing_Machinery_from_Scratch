program addition

    implicit none

    integer :: reg_a 
    integer :: reg_b  
    integer :: output 
    
    reg_a = 9   

    reg_b = 3   

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
    
end program addition
