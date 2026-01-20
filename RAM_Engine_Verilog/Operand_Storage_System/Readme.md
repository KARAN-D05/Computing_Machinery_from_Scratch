# 🔒Operand Storage System
- It is the combination of 2 sets of 4 D-Flip-Flops, 4 Demultiplexers, a Selector Pin and a Store Pin.
- Used to route and store the operands in the desired latch.

<p align="center">
  <img src="images/waveform.png" 
       width="2000"/>
  <br>
  <sub><b> Testbench Waveform
</p>

## ⚙️Working Principle
- Manually Clocked D-Flip-Flops
  - They are used to store the operand.
  - Two sets of 4-D Flip-Flops, thus giving the capability to store two 4-bit operands.
  
- Demultiplexer:
  - Routes the 4-Bit operand to the desired Latches.

t=0 | data_in = 1000 | sel_t = 0 | store_t = 0 |reset_t = 0 | d_ff1t = xxxx | dff2t = xxxx
t=5 | data_in = 1000 | sel_t = 0 | store_t = 1 |reset_t = 0 | d_ff1t = 1000 | dff2t = xxxx
t=10 | data_in = 0000 | sel_t = 1 | store_t = 1 |reset_t = 1 | d_ff1t = 0000 | dff2t = 0000
t=15 | data_in = 1011 | sel_t = 1 | store_t = 0 |reset_t = 0 | d_ff1t = 0000 | dff2t = 0000
t=20 | data_in = 1011 | sel_t = 1 | store_t = 1 |reset_t = 0 | d_ff1t = 0000 | dff2t = 1011
t=25 | data_in = 1111 | sel_t = 0 | store_t = 0 |reset_t = 0 | d_ff1t = 0000 | dff2t = 1011
t=30 | data_in = 1111 | sel_t = 0 | store_t = 1 |reset_t = 0 | d_ff1t = 1111 | dff2t = 1011
t=35 | data_in = 1001 | sel_t = 1 | store_t = 1 |reset_t = 0 | d_ff1t = 1111 | dff2t = 1011
t=40 | data_in = 0001 | sel_t = 0 | store_t = 0 |reset_t = 0 | d_ff1t = 1111 | dff2t = 1011
t=45 | data_in = 1101 | sel_t = 1 | store_t = 0 |reset_t = 1 | d_ff1t = 0000 | dff2t = 0000
t=50 | data_in = 1101 | sel_t = 1 | store_t = 1 |reset_t = 1 | d_ff1t = 0000 | dff2t = 0000
Simulation Complete!

- Selector Pin:
  - Based on its value the path to send the data is decided.

- Store Pin:
  - Stores the operand when it goes from 0 to 1.

<p align="center">
  <img src="images/Output_Terminal.png" 
       width="900"/>
  <br>
  <sub><b> Output Terminal
</p
