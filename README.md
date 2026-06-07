# mgtm98 PCIe5 PHY VCS 验证环境

本仓库基于 `mgtm98/pcie5_phy` 项目整理，包含 PCIe5 PHY RTL、原有 UVM 验证环境，以及面向 VCS/Verdi/DVE 的仿真入口。

## 运行方式

在仓库根目录执行：

```sh
make com
make run tc=pcie_test seed=123
make verdi tc=pcie_test seed=123
make regress
make cov
```

也可以进入 `tb/sim` 后执行同样的命令。

## 输出目录

仿真输出统一放在 `tb/sim/output/`：

- `log/`：编译、仿真和覆盖率日志
- `wave/`：FSDB 波形文件
- `simv/`：VCS 可执行文件和编译数据库
- `cov/`：VCS 覆盖率数据库和合并后的覆盖率结果
- `meta/`：编译 filelist 备份和运行元信息

## 项目文档

- `docs/rtl_architecture.md`
- `docs/rtl_function_description.md`
- `docs/tb_architecture.md`
- `docs/verification_cases.md`
