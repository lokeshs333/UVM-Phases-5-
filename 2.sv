`include "uvm_macros.svh"
import uvm_pkg::*;

//////////////////////////////////////////////////
// Driver component.
//////////////////////////////////////////////////
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path = "test", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  // Driver build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("driver","Driver Build Phase Executed", UVM_NONE);
  endfunction
  
endclass

//////////////////////////////////////////////////
// Monitor component.
//////////////////////////////////////////////////
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  function new(string path = "monitor", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  // Monitor build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("monitor","Monitor Build Phase Executed", UVM_NONE);
  endfunction
  
endclass

//////////////////////////////////////////////////
// Environment containing the driver and monitor.
//////////////////////////////////////////////////
class env extends uvm_env;
  `uvm_component_utils(env)
  
  driver drv;
  monitor mon;
  
  function new(string path = "env", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  // Create child components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("env","Env Build Phase Executed", UVM_NONE);

    drv = driver::type_id::create("drv", this);
    mon = monitor::type_id::create("mon", this);
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
  
  // Create the environment
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("test","Test Build Phase Executed", UVM_NONE);

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
run_test("test") starts the UVM phasing mechanism.
The test is created first, followed by the environment.
During the environment's build_phase(), the driver and monitor are created using the UVM factory.
The build_phase() executes top-down through the component hierarchy.

Build hierarchy:

uvm_test_top (test)
        │
        ▼
       env
      /   \
   driver monitor

Build phase execution order:

test.build_phase()
        ↓
env.build_phase()
        ↓
driver.build_phase()
        ↓
monitor.build_phase()





