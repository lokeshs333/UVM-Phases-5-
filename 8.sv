`include "uvm_macros.svh"
import uvm_pkg::*;

/// Default UVM timeout = 9200 seconds

//////////////////////////////////////////////////
// UVM component demonstrating drain time between
// runtime phases.
//////////////////////////////////////////////////
class comp extends uvm_component;
  `uvm_component_utils(comp)
  
  function new(string path = "comp", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  // Perform reset operations
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("comp","Reset Started", UVM_NONE);
    #10;
    `uvm_info("comp","Reset Completed", UVM_NONE);

    phase.drop_objection(this);
  endtask
  
  // Execute main test stimulus
  task main_phase(uvm_phase phase);

    // Delay phase completion after objections are dropped
    phase.phase_done.set_drain_time(this, 200);

    phase.raise_objection(this);

    `uvm_info("mon", "Main Phase Started", UVM_NONE);
    #100;
    `uvm_info("mon", "Main Phase Ended", UVM_NONE);

    phase.drop_objection(this);
  endtask
  
  // Executes after main_phase completes
  task post_main_phase(uvm_phase phase);
    `uvm_info("mon", "Post-Main Phase Started", UVM_NONE);
  endtask
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
endclass

//////////////////////////////////////////////////
// Top-level testbench
// Starts the UVM test.
//////////////////////////////////////////////////
module tb;
  
  initial begin
    // uvm_top.set_timeout(100ns, 0);

    run_test("comp");
  end
  
endmodule











What this example demonstrates
phase.phase_done.set_drain_time(this, 200) adds a 200 time-unit delay after the last objection is dropped.
During the drain time, the current phase remains active even though all objections have been cleared.
After the drain time expires, UVM transitions to the next runtime phase.
post_main_phase() starts only after main_phase() finishes and the configured drain time has elapsed.

Phase timeline:

reset_phase (10)
      ↓
main_phase starts
      │
      ├── #100 stimulus
      ├── drop_objection()
      ├── 200 time-unit drain time
      ↓
post_main_phase

Use case: Drain time is useful when monitors, scoreboards, or other components need extra time to process pending transactions after the driver has finished generating stimulus.
