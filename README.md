# mgtm98 PCIe5 PHY VCS Verification Environment

This repository contains the PCIe5 PHY RTL from `mgtm98/pcie5_phy` plus a VCS/Verdi/DVE oriented UVM verification flow.

## Run

From the repository root:

```sh
make com
make run tc=pcie_test seed=123
make verdi tc=pcie_test seed=123
make regress
make cov
```

The same commands can be run from `tb/sim`.

## Output

Simulation output is generated under `tb/sim/output/`:

- `log/`: compile, run, and coverage logs
- `wave/`: FSDB files
- `simv/`: VCS executable and compile database
- `cov/`: VCS coverage databases and merged coverage
- `meta/`: copied filelists and run metadata

## Documents

- `docs/rtl_architecture.md`
- `docs/rtl_function_description.md`
- `docs/tb_architecture.md`
- `docs/verification_cases.md`
