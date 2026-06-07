# Testbench Architecture

## Overview

The verification environment is a UVM testbench with separate HVL and HDL tops:

- `tb/top/hvl_top.sv`: imports UVM/test packages and calls `run_test()`.
- `tb/top/hdl_top.sv`: instantiates LPIF/PIPE interfaces, BFM modules, and the `PCIe` DUT.

`hdl_top` also places BFM handles into `uvm_config_db` for the UVM test and controls FSDB dumping through `+WAVES` and `+FSDB_FILE`.

## Package Build Order

The VCS filelist compiles packages in this order:

1. `common_pkg`
2. `utility_pkg`
3. LPIF/PIPE interfaces
4. `pipe_agent_pkg`
5. `lpif_agent_pkg`
6. BFM modules
7. `pcie_env_pkg`
8. `pcie_seq_pkg`
9. `pcie_test_pkg`
10. HDL/HVL tops

## Agents

- LPIF agent: sequence item, driver, monitor, coverage monitor, and BFM wrappers for LPIF traffic.
- PIPE agent: sequence item, driver, monitor, coverage monitor, and BFM wrappers for PIPE traffic.

Both agents publish sent/received transactions through analysis ports to the environment scoreboard and coverage monitor.

## Environment

`pcie_env` builds:

- `lpif_agent`
- `pipe_agent`
- `pcie_scoreboard`
- `pcie_coverage_monitor`

The scoreboard currently wires analysis FIFOs and receive callbacks. Functional comparison logic is a future extension point.

## Test and Sequence Control

`pcie_test` reads `+VSEQ=<comma-separated-list>`, creates each virtual sequence by factory name, assigns LPIF/PIPE sequencers, and runs them in order. The default VCS flow uses:

```sh
+VSEQ=reset_vseq,link_up_vseq
```

## VCS Flow

The user entry points are:

- `make com`: compile with VCS
- `make run tc=pcie_test seed=123`: run one test
- `make verdi`: open FSDB with Verdi
- `make cov`: open merged coverage with DVE
- `make regress`: run all cases in `tb/sim/filelist/regress.list`

Simulation output is under `tb/sim/output/` with `log/`, `wave/`, `simv/`, `cov/`, and `meta/` subdirectories.
