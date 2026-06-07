SHELL := /bin/bash

tc        ?= pcie_test
seed      ?= 1
verbosity ?= UVM_MEDIUM
waves     ?= 1
vseq      ?= reset_vseq,link_up_vseq
sim_timeout ?= 200000

VCS       ?= /home/synopsys/vcs-mx/O-2018.09-1/bin/vcs
VERDI     ?= /home/synopsys/verdi/Verdi_O-2018.09-SP2/bin/verdi
DVE       ?= dve

OUT_DIR   := output
LOG_DIR   := $(OUT_DIR)/log
WAVE_DIR  := $(OUT_DIR)/wave
SIMV_DIR  := $(OUT_DIR)/simv
COV_DIR   := $(OUT_DIR)/cov
META_DIR  := $(OUT_DIR)/meta
SIMV      := $(SIMV_DIR)/simv
FSDB      := $(WAVE_DIR)/$(tc)_$(seed).fsdb
COMP_LOG  := $(LOG_DIR)/com.log
RUN_LOG   := $(LOG_DIR)/run_$(tc)_$(seed).log

COMMON_FLIST := filelist/common.f
RTL_FLIST    := filelist/rtl.f
TB_FLIST     := filelist/tb.f
CASE_LIST    := filelist/regress.list

VCS_OPTS += -full64 -sverilog -timescale=1ns/1ps -ntb_opts uvm-1.2
VCS_OPTS += -debug_access+all -kdb -lca
VCS_OPTS += -cm line+cond+tgl+fsm+branch
VCS_OPTS += +vcs+lic+wait
VCS_OPTS += +define+UVM_NO_DEPRECATED
VCS_OPTS += +define+IS_ENV_UPSTREAM=1
VCS_OPTS += +define+PIPE_MAX_WIDTH=32
VCS_OPTS += +define+NUM_OF_LANES=16
VCS_OPTS += +define+LPIF_BUS_WIDTH=512
VCS_OPTS += +incdir+..
VCS_OPTS += +incdir+../utility
VCS_OPTS += +incdir+../agents/pipe_agent
VCS_OPTS += +incdir+../agents/lpif_agent
VCS_OPTS += +incdir+../env
VCS_OPTS += +incdir+../sequences
VCS_OPTS += +incdir+../test
VCS_OPTS += +incdir+../top

RUN_OPTS += +UVM_NO_RELNOTES
RUN_OPTS += +UVM_TESTNAME=$(tc)
RUN_OPTS += +UVM_VERBOSITY=$(verbosity)
RUN_OPTS += +ntb_random_seed=$(seed)
RUN_OPTS += +VSEQ=$(vseq)
RUN_OPTS += +WAVES=$(waves)
RUN_OPTS += +FSDB_FILE=$(FSDB)
RUN_OPTS += +SIM_TIMEOUT_NS=$(sim_timeout)
RUN_OPTS += -cm line+cond+tgl+fsm+branch
RUN_OPTS += -cm_dir $(COV_DIR)/$(tc)_$(seed).vdb

.PHONY: help com comp run verdi cov regress list clean distclean dirs

help:
	@echo "PCIE5 PHY VCS verification flow"
	@echo ""
	@echo "Commands:"
	@echo "  make com                         Compile with VCS"
	@echo "  make run tc=pcie_test seed=123   Compile and run one test"
	@echo "  make verdi                       Open FSDB with Verdi"
	@echo "  make cov                         Open merged coverage with DVE"
	@echo "  make regress                     Run all regress.list cases"
	@echo "  make list                        List available tests and vseqs"
	@echo "  make clean                       Remove sim output"
	@echo ""
	@echo "Variables:"
	@echo "  tc=$(tc) seed=$(seed) waves=$(waves) verbosity=$(verbosity) sim_timeout=$(sim_timeout)"
	@echo "  vseq=$(vseq)"

dirs:
	@mkdir -p $(LOG_DIR) $(WAVE_DIR) $(SIMV_DIR) $(COV_DIR) $(META_DIR)

com comp: dirs
	$(VCS) $(VCS_OPTS) -f $(COMMON_FLIST) -o $(SIMV) -Mdir=$(SIMV_DIR)/csrc -l $(COMP_LOG)
	@cp $(COMMON_FLIST) $(RTL_FLIST) $(TB_FLIST) $(META_DIR)/
	@echo "$(VCS) $(VCS_OPTS) -f $(COMMON_FLIST) -o $(SIMV)" > $(META_DIR)/compile.cmd

run: com
	$(SIMV) $(RUN_OPTS) -l $(RUN_LOG)
	@if grep -Eq 'UVM_(ERROR|FATAL)[[:space:]]*:[[:space:]]*[1-9]' $(RUN_LOG); then \
	  echo "UVM errors or fatals found in $(RUN_LOG)"; \
	  exit 1; \
	fi
	@echo "tc=$(tc) seed=$(seed) vseq=$(vseq) fsdb=$(FSDB)" > $(META_DIR)/run_$(tc)_$(seed).meta

verdi:
	@if [ ! -f "$(FSDB)" ]; then echo "FSDB not found: $(FSDB). Run make run tc=$(tc) seed=$(seed) waves=1 first."; exit 1; fi
	$(VERDI) -sv -f $(COMMON_FLIST) -ssf $(FSDB) &

cov:
	@if [ ! -d "$(COV_DIR)/merged.vdb" ]; then echo "Merged coverage not found. Run make regress first."; exit 1; fi
	$(DVE) -covdir $(COV_DIR)/merged.vdb &

regress: com
	@set -e; \
	while read line; do \
	  [[ -z "$$line" || "$$line" =~ ^# ]] && continue; \
	  set -- $$line; \
	  test_name=$$1; test_seed=$${2:-$(seed)}; test_vseq=$${3:-$(vseq)}; \
	  echo "Running $$test_name seed=$$test_seed vseq=$$test_vseq"; \
	  $(SIMV) +UVM_NO_RELNOTES +UVM_TESTNAME=$$test_name +UVM_VERBOSITY=$(verbosity) \
	    +ntb_random_seed=$$test_seed +VSEQ=$$test_vseq +WAVES=$(waves) \
	    +FSDB_FILE=$(WAVE_DIR)/$${test_name}_$${test_seed}.fsdb \
	    +SIM_TIMEOUT_NS=$(sim_timeout) \
	    -cm line+cond+tgl+fsm+branch -cm_dir $(COV_DIR)/$${test_name}_$${test_seed}.vdb \
	    -l $(LOG_DIR)/run_$${test_name}_$${test_seed}.log; \
	  if grep -Eq 'UVM_(ERROR|FATAL)[[:space:]]*:[[:space:]]*[1-9]' $(LOG_DIR)/run_$${test_name}_$${test_seed}.log; then \
	    echo "UVM errors or fatals found in $(LOG_DIR)/run_$${test_name}_$${test_seed}.log"; \
	    exit 1; \
	  fi; \
	done < $(CASE_LIST)
	@urg -full64 -dir $(COV_DIR)/*.vdb -dbname $(COV_DIR)/merged.vdb -report $(COV_DIR)/urg_report -log $(LOG_DIR)/urg.log

list:
	@echo "Tests:"
	@sed -n 's/^\([^# ][^ ]*\).*/  \1/p' $(CASE_LIST) | sort -u
	@echo "Virtual sequences:"
	@echo "  reset_vseq"
	@echo "  link_up_vseq"
	@echo "  enter_recovery_vseq"
	@echo "  data_exchange_vseq"
	@echo "  speed_change_dsp_vseq"
	@echo "  speed_change_usp_vseq"

clean:
	@rm -rf $(OUT_DIR)

distclean: clean
	@rm -rf csrc simv simv.daidir ucli.key novas.* *.vdb *.fsdb *.log
