`include "uvm_macros.svh"
import uvm_pkg::*;

//////////////////////////////////////////////////
// UVM test demonstrating the execution order of
// the common UVM phases.
//////////////////////////////////////////////////
class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(string path = "test", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  //////////////////////////// Construction Phases

  // Create and configure components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("test","Build Phase Executed", UVM_NONE);
  endfunction
  
  // Connect TLM ports and exports
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("test","Connect Phase Executed", UVM_NONE);
  endfunction

  // Finalize hierarchy before simulation
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("test","End of Elaboration Phase Executed", UVM_NONE);
  endfunction

  // Perform last-minute simulation setup
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    `uvm_info("test","Start of Simulation Phase Executed", UVM_NONE);
  endfunction

  //////////////////////////// Main Phase

  // Execute stimulus
  task run_phase(uvm_phase phase);
    `uvm_info("test", "Run Phase", UVM_NONE);
  endtask

  //////////////////////////// Cleanup Phases

  // Collect final simulation data
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    `uvm_info("test", "Extract Phase", UVM_NONE);
  endfunction

  // Verify simulation results
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    `uvm_info("test", "Check Phase", UVM_NONE);
  endfunction

  // Generate final report
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("test", "Report Phase", UVM_NONE);
  endfunction

  // Final cleanup before simulation ends
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("test", "Final Phase", UVM_NONE);
  endfunction

endclass

//////////////////////////////////////////////////
// Top-level testbench
// Starts the UVM test and executes all phases.
//////////////////////////////////////////////////
module tb;
  
  initial begin
    run_test("test");
  end
  
endmodule






What this example demonstrates
Construction phases
build_phase() → Creates and configures components.
connect_phase() → Connects TLM ports, exports, and FIFOs.
end_of_elaboration_phase() → Finalizes the component hierarchy.
start_of_simulation_phase() → Performs final setup before simulation starts.
Main phase
run_phase() → Executes the test stimulus and runtime behavior.
Cleanup phases
extract_phase() → Collects data after simulation.
check_phase() → Verifies expected results.
report_phase() → Prints the final simulation summary.
final_phase() → Performs final cleanup before simulation exits.

Execution order:

build_phase
      ↓
connect_phase
      ↓
end_of_elaboration_phase
      ↓
start_of_simulation_phase
      ↓
run_phase
      ↓
extract_phase
      ↓
check_phase
      ↓
report_phase
      ↓
final_phase

