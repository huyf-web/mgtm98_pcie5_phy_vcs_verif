# RTL 功能描述文档

## 顶层与集成模块

- `PCIE.v`：`PCIe` 顶层模块，集成 main LTSSM、RX 和 TX 顶层。文件中还包含旧的独立 `pcieTB` 模块。
- `maintlssm.v`：主链路训练状态机，协调 detect、polling、configuration、recovery、speed change、equalization 和 link-up 行为。
- `Modules Integration.v`：`RX` 接收侧集成顶层，连接接收侧控制路径和数据路径。
- `TX .v`：`TOP_MODULE` 发送侧集成顶层。

## TX 发送路径

- `TxLtssm.v`：TX 侧 LTSSM 子状态逻辑。
- `Master.v`、`Master_Tx.v`、`MasterTX.v`：TX master 数据和控制生成逻辑的不同版本。
- `TX_Control.v`、`Tx_CTRL.v`：发送控制辅助逻辑，用于状态、generation 和 PIPE 控制信号处理。
- `DataHandling.v`：LPIF 数据和控制信息进入发送数据路径前的处理。
- `Gen1_2_DataPath.v`：Gen1/Gen2 发送数据格式化。
- `Gen3_DataPath.v`：Gen3 及以上发送数据格式化。
- `Insert_token_block.v`、`InsertBlockToken_G3.v`：插入协议 block/token 标记。
- `Scrambler.v`：发送侧 scrambling。
- `MUX.v`、`Gen_mux.v`、`Gen_ctrl.v`：generation 相关的数据选择和控制逻辑。

## RX 接收路径

- `RxLTSSM.v`、`Master_RX_LTSSM.v`：接收侧 LTSSM 与 master receive 状态控制。
- `Lane_Management_Control.v`、`LMC.v`：lane 管理、link/lane 编号和 lane 配置逻辑。
- `PIPE_Data.v`、`PIPE_Rx_Data.v`、`PIPE_Control.v`：PIPE 接收数据和控制处理。
- `LPIF RX Control & Data Flow.v`：把接收侧解码后的数据和控制信息转换为 LPIF 接收侧信号。
- `Descrambler.v`：接收侧 descrambling。
- `UnStriping.v`：多 lane 数据 unstriping。
- `packet_identifier.v`：TLP、DLLP 和数据边界识别。
- `osDecoder.v`、`OS_Checker.v`、`OS_GENERATOR.v`：ordered set 的解码、检查和生成。

## 公共辅助模块

- `LFSR_8.v`、`LFSR_16.v`、`LFSR_32.v`：Gen1/Gen2 scrambling 使用的 LFSR。
- `LFSR_8_gen3.v`、`LFSR_16_gen3.v`、`LFSR_32_gen3.v`：Gen3 相关 LFSR。
- `check_byte.v`、`Gen_3_check_byte.v`：byte/check-symbol 检查辅助逻辑。
- `FIFOV2.v`：数据路径缓冲 FIFO。
- `LENGTH_COUNTER.v`：packet 长度统计和控制标记传递。
- `Timer.v`、`Counter.v`、`comparator.v`：计时、计数和比较辅助逻辑。

## 旧版独立 testbench

以下 RTL 目录文件属于旧版临时 testbench 或示例文件，VCS UVM RTL filelist 中故意不编译它们：`Descrambler_tb.v`、`LMC_tb.v`、`LPIF_tb.v`、`PIPERxDataTb.v`、`pcieTB.v`、`rxltssmTB.v`、`tb.v`、`topmodule.v`、`tx_test.v`。
