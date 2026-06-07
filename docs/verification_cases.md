# Verification Case Document

## Test Class

`pcie_test` is the single UVM test class. It configures LPIF and PIPE agents, creates `pcie_env`, and runs virtual sequences selected by the `+VSEQ` plusarg.

## Virtual Sequences

- `reset_vseq`: drives LPIF reset sequence.
- `link_up_vseq`: runs LPIF and PIPE link-up sequences in parallel.
- `enter_recovery_vseq`: drives LPIF/PIPE recovery entry behavior.
- `data_exchange_vseq`: drives LPIF transmit traffic and matching PIPE traffic sequence.
- `speed_change_dsp_vseq`: downstream-port speed change without equalization.
- `speed_change_usp_vseq`: upstream-port speed change without equalization.
- `dummy_vseq`: placeholder virtual sequence for connectivity/debug.

## Regression List

The initial regression file is `tb/sim/filelist/regress.list`:

| Case | Seed | VSEQ |
| --- | ---: | --- |
| `pcie_test` | 1 | `reset_vseq,link_up_vseq` |
| `pcie_test` | 2 | `reset_vseq,link_up_vseq,enter_recovery_vseq` |
| `pcie_test` | 3 | `reset_vseq,link_up_vseq,data_exchange_vseq` |
| `pcie_test` | 4 | `reset_vseq,link_up_vseq,speed_change_dsp_vseq` |
| `pcie_test` | 5 | `reset_vseq,link_up_vseq,speed_change_usp_vseq` |

## Example Commands

```sh
make com
make run tc=pcie_test seed=123
make run tc=pcie_test seed=123 vseq=reset_vseq,link_up_vseq,data_exchange_vseq
make regress
make verdi tc=pcie_test seed=123
make cov
```

## Current Coverage/Checking Status

The environment contains coverage monitor classes and a scoreboard skeleton. The current first version focuses on compiling and executing existing LPIF/PIPE stimulus through the VCS flow. Scoreboard comparison rules and coverage goals should be expanded after detailed protocol requirements are finalized.
