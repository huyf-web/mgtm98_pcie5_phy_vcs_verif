# PCIe5 PHY RTL 架构文档

## 顶层结构

UVM 环境使用的 RTL 顶层是 `rtl/PCIE.v` 中的 `PCIe` 模块。该顶层主要连接三个功能块：

- `mainLTSSM`：全局链路训练状态控制模块。它仲裁 LPIF 状态请求、TX/RX 完成标志、lane/rate 信息、directed speed change、均衡提示以及 link-up 状态。
- `RX`：接收通路和接收侧 LTSSM 集成模块。它消费 PIPE RX 数据和状态，完成 ordered set/packet 解码，更新 lane、rate、link 信息，并驱动 LPIF 接收侧输出。
- `TOP_MODULE`：发送通路和 TX 侧 LTSSM 集成模块。它消费 LPIF 发送数据和控制信息，生成 PIPE TX 数据和控制信号，并向主 LTSSM 汇报训练进度。

`PCIe` 的外部接口可以分为 PIPE、LPIF、均衡控制、状态控制四组信号。验证环境中的 `tb/top/tb.sv` 定义统一 `tb` 顶层，并在 `tb.dut` 下例化 `PCIe`，负责把 UVM LPIF/PIPE interface 映射到 `PCIe` 端口。

## 控制流

1. 软件可见的 LPIF 状态请求从 `PCIe.lp_state_req` 进入设计。
2. `mainLTSSM` 根据当前链路状态选择 LTSSM 子状态和目标 generation，并驱动 TX/RX 两侧状态目标。
3. TX 与 RX 模块和 `mainLTSSM` 交换 detected lane、link number、rate ID、preset、完成标志等信息。
4. 链路建立状态通过 `pl_linkUp` 输出，LPIF 状态通过 `pl_state_sts` 汇报。

## 数据流

发送方向：

`LPIF lp_*` -> `TOP_MODULE` -> token 插入 / scrambling / 数据选择 -> `PIPE Tx*`

接收方向：

`PIPE Rx*` -> `RX` -> ordered set 检查 / descrambling / packet 识别 -> `LPIF pl_*`

## Generation 支持

设计通过参数和宏配置 Gen1 到 Gen5 的 PIPE 宽度、最大 generation、lane 数量和最大 PIPE 数据宽度。Gen1/Gen2 与 Gen3+ 的数据路径在 RTL 中分开实现，相关文件包括 `Gen1_2_DataPath.v`、`Gen3_DataPath.v`、`Insert_token_block.v` 和 `InsertBlockToken_G3.v`。

## 验证环境接入信息

- DUT 顶层：`PCIe`
- TB 顶层模块：`tb`
- Verdi DUT 路径：`/tb/dut`
- PIPE interface：`tb/agents/pipe_agent/pipe_if.sv`
- LPIF interface：`tb/agents/lpif_agent/lpif_if.sv`
- 默认 VCS 编译入口：`tb/sim/filelist/common.f`
- FSDB dump 控制：`+WAVES=1 +FSDB_FILE=<path>`
