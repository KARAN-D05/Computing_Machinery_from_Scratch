program subtraction

    implicit none

    integer :: reg_a   
    integer :: reg_b
    integer :: output  

    reg_a = 14  

    reg_b = 6
    
    output = reg_a - reg_b

    print *, "============================================"
    print *, " RAM Machine - Subtraction"
    print *, "============================================"
    print *, " CASE 1: A > B (Positive Result)"
    print *, "--------------------------------------------"
    print *, " Selector=0  ->  Register A = ", reg_a
    print *, " Selector=1  ->  Register B = ", reg_b
    print *, " Mode=1      ->  Subtraction"
    print *, " A - B = ", output
    print *, "--------------------------------------------"

    reg_a = 3    

    reg_b = 9    
    
    output = reg_a - reg_b

    print *, " CASE 2: B > A (Negative Result)"
    print *, "--------------------------------------------"
    print *, " Selector=0  ->  Register A = ", reg_a
    print *, " Selector=1  ->  Register B = ", reg_b
    print *, " Mode=1      ->  Subtraction"
    print *, " A - B = ", output
    print *, " Result is negative."
    print *, " V0: errors below 0, no handling."
    print *, " V1: manual B>A pin required before SUB."
    print *, " V2+: comparator auto-detects B>A."
    print *, "--------------------------------------------"

end program subtraction
