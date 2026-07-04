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
  
  // Driver connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("driver","Driver Connect Phase Executed", UVM_NONE);
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
  
  // Monitor connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("monitor","Monitor Connect Phase Executed", UVM_NONE);
  endfunction
  
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
  
  // Connect child components
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("env","Env Connect Phase Executed", UVM_NONE);
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
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
  endfunction
  
  // Test connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("test","Test Connect Phase Executed", UVM_NONE);
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
connect_phase() is used to connect TLM ports, exports, analysis ports, and FIFOs after all components have been created.
The driver and monitor are created in build_phase(), making them available during connect_phase().
The connect_phase() executes top-down through the UVM hierarchy.

Component hierarchy:

uvm_test_top (test)
        │
        ▼
       env
      /   \
  driver  monitor

Connect phase execution order:

test.connect_phase()
        ↓
env.connect_phase()
        ↓
driver.connect_phase()
        ↓
monitor.connect_phase()

Note: In practical UVM environments, connect_phase() is typically where the driver is connected to the sequencer and monitors are connected to scoreboards or coverage collectors.
