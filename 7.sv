`include "uvm_macros.svh"
import uvm_pkg::*;

/// Default UVM timeout : 9200 seconds

//////////////////////////////////////////////////
// UVM component demonstrating runtime phases
// with a custom simulation timeout.
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
    phase.raise_objection(this);

    `uvm_info("mon", "Main Phase Started", UVM_NONE);
    #100;
    `uvm_info("mon", "Main Phase Ended", UVM_NONE);

    phase.drop_objection(this);
  endtask
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
endclass

//////////////////////////////////////////////////
// Top-level testbench
// Sets the UVM timeout and starts the test.
//////////////////////////////////////////////////
module tb;
  
  initial begin

    // Set simulation timeout to 100 ns
    uvm_top.set_timeout(100ns, 0);

    run_test("comp");
  end
  
endmodule










What this example demonstrates
uvm_top.set_timeout(100ns, 0) sets the maximum simulation time to 100 ns.
If the simulation does not complete before the timeout, UVM terminates the simulation with a timeout error.
The second argument (0) prevents later calls from overriding the timeout value.
In this example:
reset_phase() takes 10 ns.
main_phase() takes 100 ns.
Since the total runtime exceeds the configured timeout, the simulation times out before completing main_phase().




