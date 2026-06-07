# 验证用例文档

## 测试类

`pcie_test` 是当前环境中的唯一 UVM test class。它配置 LPIF 和 PIPE agent，创建 `pcie_env`，并运行由 `+VSEQ` plusarg 指定的 virtual sequence。

## Virtual Sequence

- `reset_vseq`：驱动 LPIF reset sequence。
- `link_up_vseq`：并行运行 LPIF 和 PIPE link-up sequence。
- `enter_recovery_vseq`：驱动 LPIF/PIPE 进入 recovery 的行为。
- `data_exchange_vseq`：驱动 LPIF 发送数据，并配合 PIPE 侧数据传输 sequence。
- `speed_change_dsp_vseq`：downstream port 不带均衡的 speed change sequence。
- `speed_change_usp_vseq`：upstream port 不带均衡的 speed change sequence。
- `dummy_vseq`：用于连通性和调试的占位 virtual sequence。

## 回归列表

初版回归列表位于 `tb/sim/filelist/regress.list`：

| Case | Seed | VSEQ |
| --- | ---: | --- |
| `pcie_test` | 1 | `reset_vseq,link_up_vseq` |
| `pcie_test` | 2 | `reset_vseq,link_up_vseq,enter_recovery_vseq` |
| `pcie_test` | 3 | `reset_vseq,link_up_vseq,data_exchange_vseq` |
| `pcie_test` | 4 | `reset_vseq,link_up_vseq,speed_change_dsp_vseq` |
| `pcie_test` | 5 | `reset_vseq,link_up_vseq,speed_change_usp_vseq` |

## 命令示例

```sh
make com
make run tc=pcie_test seed=123
make run tc=pcie_test seed=123 vseq=reset_vseq,link_up_vseq,data_exchange_vseq
make regress
make verdi tc=pcie_test seed=123
make cov
```

## 当前覆盖率与检查状态

环境中已经包含 coverage monitor class 和 scoreboard 框架。当前初版重点是把已有 LPIF/PIPE stimulus 接入 VCS 流程并能够编译运行；scoreboard 比对规则和覆盖率目标需要在详细协议检查需求确定后继续扩展。
