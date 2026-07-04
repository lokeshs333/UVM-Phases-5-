`include "uvm_macros.svh"
import uvm_pkg::*;

//////////////////////////////////////////////////
// UVM component demonstrating the reset_phase.
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
  
endclass

//////////////////////////////////////////////////
// Top-level testbench
// Starts the UVM test to execute reset_phase.
//////////////////////////////////////////////////
module tb;
  
  initial begin
    run_test("comp");
  end
  
endmodule





What this example demonstrates
reset_phase() is a runtime phase used to perform DUT reset operations.
raise_objection() prevents the phase from ending while the reset is in progress.
After the reset activity completes, drop_objection() allows the phase to finish.
In this example, a 10-time-unit reset is simulated using #10.
Runtime phases such as reset_phase() execute automatically when run_test() starts the UVM phase schedule.


