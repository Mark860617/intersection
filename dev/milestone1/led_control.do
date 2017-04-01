vlib work
vlog -timescale 1ns/1ns led_control.v
vsim -L altera_mf_ver led_control
log {/*}
add wave {/*}


force {fsmIn[0]} 0
force {fsmIn[1]} 0
force {fsmIn[2]} 0
run 5ns

force {fsmIn[0]} 1
force {fsmIn[1]} 0
force {fsmIn[2]} 0
run 5ns

force {fsmIn[0]} 0
force {fsmIn[1]} 1
force {fsmIn[2]} 0
run 5ns

force {fsmIn[0]} 1
force {fsmIn[1]} 1
force {fsmIn[2]} 0
run 5ns

force {fsmIn[0]} 0
force {fsmIn[1]} 0
force {fsmIn[2]} 1
run 5ns

force {fsmIn[0]} 1
force {fsmIn[1]} 0
force {fsmIn[2]} 1
run 5ns

force {fsmIn[0]} 0
force {fsmIn[1]} 1
force {fsmIn[2]} 1
run 5ns

force {fsmIn[0]} 1
force {fsmIn[1]} 1
force {fsmIn[2]} 1
run 5ns
