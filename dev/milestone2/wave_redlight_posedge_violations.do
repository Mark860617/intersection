# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all  mVerilogodules in mux.v to working dir;
# could also have multiple Verilog files.
# SW[1]he timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns redlight.v

# Load simulation using mux as the top level simulation module.
vsim  -L altera_mf_ver redlight

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.
force {resetn} 0
run 20ps

force {clk} 0 0ps, 1 10ps -r 20ps
force {fsmState} 100
force {sensor} 0 0ps, 1 200ps -r 400ps
force {resetn} 1
run 1000ps