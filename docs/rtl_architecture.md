# PCIe5 PHY RTL Architecture

## Top Level

The RTL top used by the UVM environment is `PCIe` in `rtl/PCIE.v`. It connects three major blocks:

- `mainLTSSM`: global link-training state control. It arbitrates LPIF state requests, TX/RX completion flags, lane/rate information, directed speed change, equalization hints, and link-up status.
- `RX`: receive datapath and receive-side LTSSM handling. It consumes PIPE RX data/status, decodes ordered sets and packets, updates detected lane/rate/link information, and drives LPIF receive outputs.
- `TOP_MODULE`: transmit datapath and TX-side LTSSM handling. It consumes LPIF transmit data/control, generates PIPE TX data/control, and reports training progress to the main LTSSM.

The external protocol-facing ports are grouped into PIPE, LPIF, equalization, and state-control signals. `hdl_top.sv` maps the UVM LPIF/PIPE interfaces to the `PCIe` ports.

## Control Flow

1. LPIF software-visible state requests enter `PCIe.lp_state_req`.
2. `mainLTSSM` chooses the active LTSSM substate and generation, then drives TX/RX side state targets.
3. TX and RX blocks exchange detected-lane, link-number, rate-ID, preset, and completion flags with `mainLTSSM`.
4. Link-up and LPIF status are reported through `pl_linkUp` and `pl_state_sts`.

## Data Flow

Transmit path:

`LPIF lp_*` -> `TOP_MODULE` -> token insertion / scrambling / data steering -> `PIPE Tx*`.

Receive path:

`PIPE Rx*` -> `RX` -> ordered-set checking / descrambling / packet identification -> `LPIF pl_*`.

## Generation Support

The design exposes parameters and macros for Gen1 through Gen5 pipe widths, maximum generation, lane count, and maximum PIPE data width. Gen1/Gen2 and Gen3+ datapaths are separated in the RTL through files such as `Gen1_2_DataPath.v`, `Gen3_DataPath.v`, `Insert_token_block.v`, and `InsertBlockToken_G3.v`.

## Verification Integration Notes

- DUT top: `PCIe`
- TB top modules: `hdl_top` and `hvl_top`
- PIPE interface: `tb/agents/pipe_agent/pipe_if.sv`
- LPIF interface: `tb/agents/lpif_agent/lpif_if.sv`
- Default VCS compile entry: `tb/sim/filelist/common.f`
- FSDB dump control: `+WAVES=1 +FSDB_FILE=<path>`
