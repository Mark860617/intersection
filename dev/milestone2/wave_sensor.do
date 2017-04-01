# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all  mVerilogodules in mux.v to working dir;
# could also have multiple Verilog files.
# SW[1]he timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns sensor.v

# Load simulation using mux as the top level simulation module.
vsim sensor

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.
force {GPIO_0} 011100000011100000000000000000000000
run 5ns

force {GPIO_0} 010101000000000000000000000000000001
run 5ns

force {GPIO_0} 100101000000000000000000000000000000
run 5ns