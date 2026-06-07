class speed_change_dsp_vseq extends base_vseq;

    `uvm_object_utils(speed_change_dsp_vseq);
  
    extern function new(string name = "speed_change_dsp_vseq");
    extern task body();
  
  endclass: speed_change_dsp_vseq
  
  function speed_change_dsp_vseq::new(string name = "speed_change_dsp_vseq");
    super.new(name);
  endfunction: new
  
  task speed_change_dsp_vseq::body();
    //handels of sequnces

    pipe_speed_change_without_eq_dsp_seq pipe_speed_change_without_eq_dsp_seq_h = pipe_speed_change_without_eq_dsp_seq::type_id::create("pipe_speed_change_without_eq_dsp_seq_h");
    int unsigned timeout_ns;
    bit seq_done;
    
  
   `uvm_info (get_type_name(), $sformatf ("start speed change without EQ seq"), UVM_MEDIUM)
    timeout_ns = 100000;
    void'($value$plusargs("SPEED_CHANGE_TIMEOUT_NS=%d", timeout_ns));

    fork
      begin
        pipe_speed_change_without_eq_dsp_seq_h.start (pipe_sequencer_h,this);
        seq_done = 1;
      end
      begin
        #timeout_ns;
        if (!seq_done) begin
          `uvm_warning(get_type_name(), $sformatf("speed change DSP sequence timed out after %0d ns", timeout_ns))
        end
      end
    join_any
    disable fork;

  endtask
