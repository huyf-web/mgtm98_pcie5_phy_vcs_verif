class speed_change_eq_vseq extends base_vseq;

  `uvm_object_utils(speed_change_eq_vseq);

  extern function new(string name = "speed_change_eq_vseq");
  extern task body();

endclass: speed_change_eq_vseq

function speed_change_eq_vseq::new(string name = "speed_change_eq_vseq");
  super.new(name);
endfunction: new

task speed_change_eq_vseq::body();
  pipe_speed_change_with_equalization_seq pipe_speed_change_with_equalization_seq_h =
    pipe_speed_change_with_equalization_seq::type_id::create("pipe_speed_change_with_equalization_seq_h");
  int unsigned timeout_ns;
  bit seq_done;

  `uvm_info(get_type_name(), "start speed change with equalization seq", UVM_MEDIUM)

  timeout_ns = 100000;
  void'($value$plusargs("SPEED_CHANGE_TIMEOUT_NS=%d", timeout_ns));

  if (!pipe_speed_change_with_equalization_seq_h.randomize() with {
      lf_usp inside {[1:63]};
      fs_usp inside {[1:63]};
      lf_dsp inside {[1:63]};
      fs_dsp inside {[1:63]};
      pre_cursor inside {[0:31]};
      cursor inside {[1:63]};
      post_cursor inside {[0:31]};
      my_tx_preset inside {[0:10]};
      my_rx_preset_hint inside {[0:7]};
    }) begin
    `uvm_error(get_type_name(), "Failed to randomize equalization sequence")
    return;
  end

  fork
    begin
      pipe_speed_change_with_equalization_seq_h.start(pipe_sequencer_h, this);
      seq_done = 1;
    end
    begin
      #timeout_ns;
      if (!seq_done) begin
        `uvm_warning(get_type_name(), $sformatf("speed change EQ sequence timed out after %0d ns", timeout_ns))
      end
    end
  join_any
  disable fork;

endtask
