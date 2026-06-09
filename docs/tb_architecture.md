# 验证平台架构文档

## 总体结构

验证环境是 UVM 验证平台，当前使用统一的 `tb` 顶层：

- `tb/top/tb.sv`：定义 `module tb`，例化 LPIF/PIPE interface、BFM 模块和 `PCIe` DUT。
- `tb.dut`：`PCIe` DUT 实例，Verdi 中可从 `/tb/dut/...` 展开 DUT 内部信号。

`tb` 同时负责把 BFM handle 放入 `uvm_config_db`，调用 `run_test()`，并通过 `+WAVES` 和 `+FSDB_FILE` 控制 FSDB dump。VCS 编译时显式使用 `-top tb`，避免 Verdi 中出现多个分散顶层。

## Package 编译顺序

VCS filelist 按以下顺序编译 package 和顶层：

1. `common_pkg`
2. `utility_pkg`
3. LPIF/PIPE interface
4. `pipe_agent_pkg`
5. `lpif_agent_pkg`
6. BFM 模块
7. `pcie_env_pkg`
8. `pcie_seq_pkg`
9. `pcie_test_pkg`
10. `tb` 顶层

## Agent

- LPIF agent：包含 sequence item、driver、monitor、coverage monitor 以及 LPIF BFM wrapper。
- PIPE agent：包含 sequence item、driver、monitor、coverage monitor 以及 PIPE BFM wrapper。

两个 agent 都通过 analysis port 把发送和接收 transaction 发布给环境中的 scoreboard 和 coverage monitor。

## Environment

`pcie_env` 负责创建：

- `lpif_agent`
- `pipe_agent`
- `pcie_scoreboard`
- `pcie_coverage_monitor`

当前 scoreboard 已经连好 analysis FIFO 和接收回调，功能级比较逻辑后续可按协议检查需求继续扩展。

## 测试与 sequence 控制

`pcie_test` 读取 `+VSEQ=<comma-separated-list>`，按 factory name 创建每个 virtual sequence，绑定 LPIF/PIPE sequencer 后依次运行。默认 VCS 流程使用：

```sh
+VSEQ=reset_vseq,link_up_vseq
```

## VCS 仿真流程

用户入口如下：

- `make com`：使用 VCS 编译环境
- `make run tc=pcie_test seed=123`：运行单个 test
- `make verdi`：使用 Verdi 打开 FSDB 波形
- `make cov`：使用 DVE 打开合并后的覆盖率
- `make regress`：运行 `tb/sim/filelist/regress.list` 中的所有 case

仿真输出位于 `tb/sim/output/`，包含 `log/`、`wave/`、`simv/`、`cov/` 和 `meta/` 子目录。
