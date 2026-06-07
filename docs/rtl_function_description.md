# RTL Function Description

## Top and Integration

- `PCIE.v`: `PCIe` top module. Integrates main LTSSM, RX, and TX top. Also contains a legacy standalone `pcieTB` module.
- `maintlssm.v`: main link-training state machine. Coordinates detect, polling, configuration, recovery, speed change, equalization, and link-up behavior.
- `Modules Integration.v`: `RX` integration top for receive-side control/data path.
- `TX .v`: `TOP_MODULE` transmit-side integration top.

## TX Path

- `TxLtssm.v`: TX LTSSM substate logic.
- `Master.v`, `Master_Tx.v`, `MasterTX.v`: TX master data/control generation variants.
- `TX_Control.v`, `Tx_CTRL.v`: transmit control helpers for state, generation, and PIPE control signals.
- `DataHandling.v`: LPIF data/control handling before transmit datapath processing.
- `Gen1_2_DataPath.v`: Gen1/Gen2 transmit data formatting.
- `Gen3_DataPath.v`: Gen3+ transmit data formatting.
- `Insert_token_block.v`, `InsertBlockToken_G3.v`: inserts protocol block/token markers.
- `Scrambler.v`: transmit scrambling.
- `MUX.v`, `Gen_mux.v`, `Gen_ctrl.v`: datapath selection and generation-specific mux/control.

## RX Path

- `RxLTSSM.v`, `Master_RX_LTSSM.v`: receive-side LTSSM and master receive state control.
- `Lane_Management_Control.v`, `LMC.v`: lane management, link/lane numbering, and lane configuration logic.
- `PIPE_Data.v`, `PIPE_Rx_Data.v`, `PIPE_Control.v`: PIPE receive data and control handling.
- `LPIF RX Control & Data Flow.v`: converts receive-side decoded data/control to LPIF receive signals.
- `Descrambler.v`: receive descrambling.
- `UnStriping.v`: lane unstriping.
- `packet_identifier.v`: packet classification for TLP/DLLP/data boundaries.
- `osDecoder.v`, `OS_Checker.v`, `OS_GENERATOR.v`: ordered-set decode, checking, and generation.

## Shared Helpers

- `LFSR_8.v`, `LFSR_16.v`, `LFSR_32.v`: LFSR generators for Gen1/Gen2 scrambling.
- `LFSR_8_gen3.v`, `LFSR_16_gen3.v`, `LFSR_32_gen3.v`: Gen3-oriented LFSR generators.
- `check_byte.v`, `Gen_3_check_byte.v`: byte/check-symbol validation helpers.
- `FIFOV2.v`: FIFO used by data path buffering.
- `LENGTH_COUNTER.v`: tracks packet length and control marker propagation.
- `Timer.v`, `Counter.v`, `comparator.v`: timing/counting comparison utilities.

## Legacy Standalone Testbenches

The following RTL-directory files are legacy ad-hoc testbenches or examples and are intentionally excluded from the VCS UVM RTL filelist: `Descrambler_tb.v`, `LMC_tb.v`, `LPIF_tb.v`, `PIPERxDataTb.v`, `pcieTB.v`, `rxltssmTB.v`, `tb.v`, `topmodule.v`, and `tx_test.v`.
