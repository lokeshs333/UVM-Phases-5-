`include "uvm_macros.svh"
import uvm_pkg::*;

//////////////////////////////////////////////////
// Driver component demonstrating runtime phases.
//////////////////////////////////////////////////
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path = "test", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  // Perform driver reset
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("drv", "Driver Reset Started", UVM_NONE);
    #100;
    `uvm_info("drv", "Driver Reset Ended", UVM_NONE);

    phase.drop_objection(this);
  endtask
  
  // Execute driver stimulus
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("drv", "Driver Main Phase Started", UVM_NONE);
    #100;
    `uvm_info("drv", "Driver Main Phase Ended", UVM_NONE);

    phase.drop_objection(this);
  endtask
  
endclass

//////////////////////////////////////////////////
// Monitor component demonstrating runtime phases.
//////////////////////////////////////////////////
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string path = "monitor", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  // Perform monitor reset
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("mon", "Monitor Reset Started", UVM_NONE);
    #300;
    `uvm_info("mon", "Monitor Reset Ended", UVM_NONE);

    phase.drop_objection(this);
  endtask
  
  // Monitor DUT activity
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("mon", "Monitor Main Phase Started", UVM_NONE);
    #400;
    `uvm_info("mon", "Monitor Main Phase Ended", UVM_NONE);

    phase.drop_objection(this);
  endtask
  
endclass

//////////////////////////////////////////////////
// Environment containing the driver and monitor.
//////////////////////////////////////////////////
class env extends uvm_env;
  `uvm_component_utils(env)
  
  driver d;
  monitor m;
  
  function new(string path = "env", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  // Create child components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    d = driver::type_id::create("d", this);
    m = monitor::type_id::create("m", this);
  endfunction
  
endclass

//////////////////////////////////////////////////
// Test that creates the environment.
//////////////////////////////////////////////////
class test extends uvm_test;
  `uvm_component_utils(test)
  
  env e;
  
  function new(string path = "test", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  // Create environment
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    e = env::type_id::create("e", this);
  endfunction
  
endclass

//////////////////////////////////////////////////
// Top-level testbench
// Starts the UVM test.
//////////////////////////////////////////////////
module tb;
  
  initial begin
    run_test("test");
  end
  
endmodule








What this example demonstrates
Both the driver and monitor participate in the UVM runtime phases.
reset_phase() for all components starts concurrently. The phase completes only after all objections are dropped.
Once reset_phase() finishes, UVM automatically starts main_phase().
main_phase() of the driver and monitor also execute in parallel.
raise_objection() keeps the current phase active, while drop_objection() signals that the component has completed its work.

Runtime phase execution:

reset_phase
 ├── Driver (100)
 └── Monitor (300)
        ↓
   reset_phase ends
        ↓
main_phase
 ├── Driver (100)
 └── Monitor (400)
        ↓
   main_phase ends

Note: A runtime phase does not complete until every component participating in that phase has dropped its objection.

