SIM_DIR := tb/sim

.PHONY: help com comp run verdi cov regress list clean distclean

help com comp run verdi cov regress list clean distclean:
	$(MAKE) -C $(SIM_DIR) $@

%:
	@:
