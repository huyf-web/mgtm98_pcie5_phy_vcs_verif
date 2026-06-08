# PCIe5 PHY 验证环境使用说明

本文档用于指导用户从获取工程开始，完整使用当前 PCIe5 PHY VCS/Verdi 验证环境，包括编译、运行单条用例、执行回归、查看 FSDB 波形、查看覆盖率以及定位常见问题。

## 1. 环境概述

当前工程基于开源 `mgtm98/pcie5_phy` RTL 整理，已经接入面向 Synopsys 工具链的验证流程。

主要内容如下：

| 路径 | 说明 |
| --- | --- |
| `rtl/` | PCIe5 PHY RTL 源码 |
| `tb/` | UVM 验证环境 |
| `tb/sim/` | VCS/Verdi/DVE 仿真入口、filelist、回归列表和输出目录 |
| `tb/sim/filelist/common.f` | 总 filelist，包含 RTL 与 TB filelist |
| `tb/sim/filelist/rtl.f` | RTL 编译文件列表 |
| `tb/sim/filelist/tb.f` | TB 编译文件列表 |
| `tb/sim/filelist/regress.list` | 回归用例列表 |
| `tb/sim/pcie5_phy_key_signals.rc` | Verdi 关键信号加载脚本 |
| `docs/` | 架构说明、用例说明、验证报告和本使用说明 |

用户日常使用时，建议优先在工程根目录执行 `make` 命令。根目录 `Makefile` 会自动转发到 `tb/sim/Makefile`。

## 2. 工具和环境要求

当前 Makefile 默认使用以下工具路径：

```sh
VCS=/home/synopsys/vcs-mx/O-2018.09-1/bin/vcs
VERDI=/home/synopsys/verdi/Verdi_O-2018.09-SP2/bin/verdi
DVE=dve
```

使用前请确认 Linux 仿真机中已经具备：

1. VCS 2018 或兼容版本。
2. Verdi 2018 或兼容版本。
3. DVE/URG 覆盖率查看与合并工具。
4. 可用的 Synopsys license。
5. `make`、`bash`、`grep`、`sed` 等基础命令。
6. 如果需要打开 Verdi 或 DVE 图形界面，需要配置 X11/图形显示环境。

如果本机工具路径与默认路径不同，可以在命令行覆盖变量：

```sh
make com VCS=/path/to/vcs
make verdi VERDI=/path/to/verdi
make cov DVE=/path/to/dve
```

也可以进入 `tb/sim/Makefile` 修改默认工具路径。

## 3. 获取和进入工程

如果是首次使用，可以从指定 GitHub 仓库克隆工程：

```sh
git clone https://github.com/huyf-web/mgtm98_pcie5_phy_vcs_verif.git
cd mgtm98_pcie5_phy_vcs_verif
```

如果工程已经存在，建议先更新到最新版本：

```sh
git pull
```

检查当前目录是否包含 `Makefile`、`rtl/`、`tb/` 和 `docs/`：

```sh
ls
```

## 4. 查看可用命令和用例

查看当前环境支持的命令：

```sh
make help
```

查看当前回归列表中的 test 和可用 virtual sequence：

```sh
make list
```

当前唯一 UVM test class 是 `pcie_test`。不同验证场景通过 `+VSEQ` 指定的 virtual sequence 组合实现。

当前支持的 virtual sequence 包括：

| Virtual Sequence | 说明 |
| --- | --- |
| `reset_vseq` | 执行基础 reset 流程 |
| `link_up_vseq` | 执行 LPIF/PIPE link-up 流程 |
| `enter_recovery_vseq` | 执行进入 recovery 的验证流程 |
| `data_exchange_vseq` | 执行数据传输验证流程 |
| `speed_change_dsp_vseq` | 执行 downstream port 不带均衡的速率切换流程 |
| `speed_change_usp_vseq` | 执行 upstream port 不带均衡的速率切换流程 |
| `speed_change_eq_vseq` | 执行带 equalization 的速率切换流程 |

## 5. 编译环境

在工程根目录执行：

```sh
make com
```

`make com` 会调用 VCS 编译 RTL 与 TB，并生成仿真可执行文件。

编译输出位置：

| 输出 | 路径 |
| --- | --- |
| 编译 log | `tb/sim/output/log/com.log` |
| VCS 可执行文件 | `tb/sim/output/simv/simv` |
| VCS 编译数据库 | `tb/sim/output/simv/csrc/` |
| 编译 filelist 备份 | `tb/sim/output/meta/` |

如果编译失败，优先查看：

```sh
less tb/sim/output/log/com.log
```

常见原因包括工具路径不正确、license 不可用、filelist 中文件缺失、SV/UVM 语法与当前工具版本不兼容。

## 6. 运行单条用例

最常用的单 case 运行命令如下：

```sh
make run tc=pcie_test seed=1
```

`make run` 会先执行编译，再运行指定 test。默认参数如下：

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `tc` | `pcie_test` | UVM test class 名称 |
| `seed` | `1` | 随机种子 |
| `verbosity` | `UVM_MEDIUM` | UVM 打印等级 |
| `waves` | `1` | 是否生成 FSDB 波形，`1` 表示生成，`0` 表示关闭 |
| `vseq` | `reset_vseq,link_up_vseq` | virtual sequence 列表 |
| `sim_timeout` | `200000` | 仿真超时时间，单位 ns |

指定 virtual sequence 的例子：

```sh
make run tc=pcie_test seed=3 vseq=reset_vseq,link_up_vseq,data_exchange_vseq
```

提高 UVM 打印等级：

```sh
make run tc=pcie_test seed=3 verbosity=UVM_HIGH
```

关闭波形以提升仿真速度：

```sh
make run tc=pcie_test seed=3 waves=0
```

调整仿真超时时间：

```sh
make run tc=pcie_test seed=3 sim_timeout=1000000
```

关闭仿真超时：

```sh
make run tc=pcie_test seed=3 sim_timeout=0
```

单 case 运行完成后，重点检查：

| 输出 | 路径 |
| --- | --- |
| 运行 log | `tb/sim/output/log/run_<tc>_<seed>.log` |
| FSDB 波形 | `tb/sim/output/wave/<tc>_<seed>.fsdb` |
| 覆盖率数据库 | `tb/sim/output/cov/<tc>_<seed>.vdb` |
| 运行元信息 | `tb/sim/output/meta/run_<tc>_<seed>.meta` |

例如：

```sh
less tb/sim/output/log/run_pcie_test_3.log
```

当前 Makefile 会检查运行 log 中是否存在非 0 个 `UVM_ERROR` 或 `UVM_FATAL`。如果存在，`make run` 会返回失败。

## 7. 执行完整回归

完整回归列表位于：

```sh
tb/sim/filelist/regress.list
```

当前回归内容如下：

| Case | Seed | VSEQ |
| --- | ---: | --- |
| `pcie_test` | 1 | `reset_vseq,link_up_vseq` |
| `pcie_test` | 2 | `reset_vseq,link_up_vseq,enter_recovery_vseq` |
| `pcie_test` | 3 | `reset_vseq,link_up_vseq,data_exchange_vseq` |
| `pcie_test` | 4 | `reset_vseq,link_up_vseq,speed_change_dsp_vseq` |
| `pcie_test` | 5 | `reset_vseq,link_up_vseq,speed_change_usp_vseq` |
| `pcie_test` | 6 | `reset_vseq,link_up_vseq,speed_change_eq_vseq` |

执行完整回归：

```sh
make regress
```

默认情况下，`make regress` 会运行所有 case 并分别生成覆盖率数据库，但不会自动合并覆盖率。

如果需要在回归结束后合并覆盖率，执行：

```sh
make regress merge_cov=1
```

合并覆盖率后会生成：

| 输出 | 路径 |
| --- | --- |
| 合并覆盖率数据库 | `tb/sim/output/cov/merged.vdb` |
| URG 报告 | `tb/sim/output/cov/urg_report/` |
| URG log | `tb/sim/output/log/urg.log` |

如果某条 case 失败，回归会停止。可以根据终端打印的 case 名称和 seed 查看对应 log：

```sh
less tb/sim/output/log/run_pcie_test_<seed>.log
```

## 8. 查看 Verdi 波形

运行用例时需要保持 `waves=1`，才会生成 FSDB：

```sh
make run tc=pcie_test seed=3 waves=1 vseq=reset_vseq,link_up_vseq,data_exchange_vseq
```

打开对应 FSDB：

```sh
make verdi tc=pcie_test seed=3
```

该命令会打开：

```sh
tb/sim/output/wave/pcie_test_3.fsdb
```

并加载：

```sh
tb/sim/pcie5_phy_key_signals.rc
```

如果提示 FSDB 不存在，请先运行对应 case，并确认 `waves=1`。

如果需要指定其他 rc 文件，可以使用：

```sh
make verdi tc=pcie_test seed=3 wave_rc=your_signal.rc
```

## 9. 查看覆盖率

查看覆盖率前，需要先执行带覆盖率合并的回归：

```sh
make regress merge_cov=1
```

然后打开 DVE 覆盖率界面：

```sh
make cov
```

`make cov` 默认打开：

```sh
tb/sim/output/cov/merged.vdb
```

如果提示 `Merged coverage not found`，说明还没有生成合并覆盖率数据库，需要先运行：

```sh
make regress merge_cov=1
```

## 10. 清理输出

清理当前仿真输出：

```sh
make clean
```

该命令会删除：

```sh
tb/sim/output/
```

深度清理历史仿真临时文件：

```sh
make distclean
```

`distclean` 会在 `clean` 基础上继续删除 `csrc`、`simv`、`simv.daidir`、`ucli.key`、`novas.*`、`*.vdb`、`*.fsdb`、`*.log` 等仿真残留。

## 11. 推荐使用流程

首次使用建议按以下顺序执行：

```sh
git pull
make clean
make list
make com
make run tc=pcie_test seed=1
make verdi tc=pcie_test seed=1
make regress merge_cov=1
make cov
```

日常新增或修改 case 后，建议执行：

```sh
make clean
make regress merge_cov=1
```

如果只调试单个 sequence，建议执行：

```sh
make run tc=pcie_test seed=10 vseq=reset_vseq,link_up_vseq,<your_vseq> verbosity=UVM_HIGH
make verdi tc=pcie_test seed=10
```

## 12. 终端配色设置

如果希望 Linux 终端显示为黑色背景、浅色文字、红色 `user@host` 提示符、蓝色路径和蓝色目录名，可以使用工程提供的终端主题脚本：

```sh
bash tools/ubuntu_terminal_theme.sh
source ~/.bashrc
```

配置后，终端提示符格式类似：

```sh
user@host:~/workdir$
```

执行 `ls -l` 时，目录名会显示为蓝色，普通文件为浅色，整体效果接近项目参考图片中的 Ubuntu 终端风格。

该脚本会修改当前 Linux 用户的 `~/.bashrc`，并使用如下标记包围配置块：

```sh
# >>> pcie5_phy_terminal_theme >>>
# <<< pcie5_phy_terminal_theme <<<
```

如果需要取消该主题，可以打开 `~/.bashrc`，删除上述两行标记之间的内容，然后重新加载：

```sh
source ~/.bashrc
```

说明：黑色背景和浅色前景通过标准终端控制序列设置，大部分常见终端可以识别。如果当前终端模拟器禁用了颜色控制序列，需要在终端软件的 Profile/Preferences 中手动设置黑色背景。

## 13. 新增回归用例的方法

新增回归用例时，通常只需要修改：

```sh
tb/sim/filelist/regress.list
```

格式如下：

```sh
<test_name> <seed> <vseq_list>
```

例如新增一条数据传输 case：

```sh
pcie_test 10 reset_vseq,link_up_vseq,data_exchange_vseq
```

新增后执行：

```sh
make regress
```

如果新增了新的 virtual sequence 文件，需要确认：

1. sequence 文件放在 `tb/sequences/`。
2. sequence 已经被 `tb/sequences/pcie_seq_pkg.sv` include。
3. sequence 名称已经被 test 或 sequence factory 识别。
4. `make list` 中的说明同步更新，避免使用者不知道新场景。

## 14. 常见问题

### 14.1 `vcs: command not found` 或工具路径不存在

说明默认 `VCS` 路径与当前机器不一致。可以临时覆盖：

```sh
make com VCS=/your/vcs/path/vcs
```

也可以修改 `tb/sim/Makefile` 中的 `VCS` 默认值。

### 14.2 License 不可用

当前 VCS 编译参数包含：

```sh
+vcs+lic+wait
```

这表示没有 license 时 VCS 会等待 license。如果长时间卡住，需要检查 license server、环境变量和工具授权。

### 14.3 仿真长时间不结束

默认 `sim_timeout=200000`，用于避免 link-up 或数据序列异常时无限运行。

如果仿真超时退出，需要查看 log 中超时前的 UVM 打印，并打开 FSDB 定位握手或状态机停留点。

如果确认某条 case 合理需要更长时间，可以增加 timeout：

```sh
make run tc=pcie_test seed=3 sim_timeout=1000000
```

### 14.4 Verdi 打不开 FSDB

先检查文件是否存在：

```sh
ls tb/sim/output/wave/
```

如果没有对应 FSDB，重新运行：

```sh
make run tc=pcie_test seed=<seed> waves=1
```

如果 FSDB 存在但 Verdi 无法打开，需要检查 `VERDI` 路径、图形显示环境和 FSDB 版本兼容性。

### 14.5 `make cov` 提示没有 merged coverage

`make cov` 只打开已经合并好的覆盖率数据库，不会自动跑回归或合并。请先执行：

```sh
make regress merge_cov=1
```

### 14.6 回归中某条 case 失败

根据失败 seed 查看对应 log：

```sh
less tb/sim/output/log/run_pcie_test_<seed>.log
```

重点搜索：

```sh
grep -n "UVM_ERROR\\|UVM_FATAL\\|timeout" tb/sim/output/log/run_pcie_test_<seed>.log
```

如需调试波形，重新单独运行该 case 并打开 Verdi：

```sh
make run tc=pcie_test seed=<seed> vseq=<failed_vseq_list> waves=1 verbosity=UVM_HIGH
make verdi tc=pcie_test seed=<seed>
```

## 15. 交付物检查清单

完成一次环境运行或验证更新后，建议检查以下内容：

| 项目 | 检查方式 |
| --- | --- |
| 编译是否通过 | `make com` 返回 0，`tb/sim/output/log/com.log` 无编译错误 |
| 单 case 是否通过 | `make run tc=pcie_test seed=<seed>` 返回 0 |
| 回归是否通过 | `make regress` 或 `make regress merge_cov=1` 返回 0 |
| 波形是否生成 | `tb/sim/output/wave/*.fsdb` 存在 |
| 覆盖率是否生成 | `tb/sim/output/cov/*.vdb` 存在 |
| 合并覆盖率是否生成 | `tb/sim/output/cov/merged.vdb` 存在 |
| 文档是否同步 | `docs/` 中用例、报告和说明与实际环境一致 |

如果修改了环境、用例或文档，完成检查后按项目要求提交并上传 GitHub：

```sh
git status
git add <changed_files>
git commit -m "<commit message>"
git push
```
