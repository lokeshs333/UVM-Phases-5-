`include "uvm_macros.svh"
import uvm_pkg::*;

//////////////////////////////////////////////////
// UVM component demonstrating reset_phase and
// main_phase execution.
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

  // Execute the main test stimulus
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("comp", "Main Phase Started", UVM_NONE);

    #100;

    `uvm_info("comp", "Main Phase Ended", UVM_NONE);

    phase.drop_objection(this);
  endtask
  
endclass

//////////////////////////////////////////////////
// Top-level testbench
// Starts the UVM test.
//////////////////////////////////////////////////
module tb;
  
  initial begin
    run_test("comp");
  end
  
endmodule













What this example demonstrates
reset_phase() is used to initialize or reset the DUT before normal operation.
main_phase() is used to execute the primary test stimulus after reset completes.
raise_objection() keeps each runtime phase active until its task finishes.
drop_objection() signals that the phase has completed and allows UVM to move to the next runtime phase.
In this example, the reset runs for 10 time units, followed by the main phase running for 100 time units.

Phase execution order:

reset_phase
     ↓
main_phase
  
