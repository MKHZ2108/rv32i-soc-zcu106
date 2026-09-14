# Acceleration Options Separated from Baseline

This directory stores datapath variants not selected in the current FPGA configuration:

- `rtl/cla_4bit.v` and `rtl/cla_32bit_group.v`: 32-bit carry-lookahead adder grouped by 4-bit blocks.
- `rtl/carry_select_adder.v`: block-based carry-select adder.
- `rtl/barrel_shifter.v`: custom combinational barrel shifter.

Baseline currently uses `ADDER_IMPL=0` and `SHIFTER_IMPL=0`, corresponding to `ripple_adder` and synthesis-inferred shift operations. The files in this directory are not part of the Vivado source set or the default regression.

Do not change `ADDER_IMPL` or `SHIFTER_IMPL` to values other than 0 unless the optional files have been added back into the source set. To experiment with them again, add the required RTL files into Vivado and the testbench source list, then run the full regression as well as standalone synthesis/timing before selecting them as the baseline.