# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all  mVerilogodules in mux.v to working dir;
# could also have multiple Verilog files.
# SW[1]he timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns emergency.v

# Load simulation using mux as the top level simulation module.
vsim emergency

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.
force {SW[9:0]} 1111110111
run 5ns

force {SW[9:0]} 1111111111
run 5ns

force {SW[9:0]} 0010111111
run 5ns

force {SW[9:0]} 1111111111
run 5ns