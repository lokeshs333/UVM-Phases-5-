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
  
  // Executes after main_phase completes
  task post_main_phase(uvm_phase phase);
    `uvm_info("drv", "Driver Post-Main Phase Started", UVM_NONE);
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
    #150;
    `uvm_info("mon", "Monitor Reset Ended", UVM_NONE);

    phase.drop_objection(this);
  endtask
  
  // Monitor DUT activity
  task main_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("mon", "Monitor Main Phase Started", UVM_NONE);
    #200;
    `uvm_info("mon", "Monitor Main Phase Ended", UVM_NONE);

    phase.drop_objection(this);
  endtask
  
  // Executes after main_phase completes
  task post_main_phase(uvm_phase phase);
    `uvm_info("mon", "Monitor Post-Main Phase Started", UVM_NONE);
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
// Test that creates the environment and sets
// drain time for the main phase.
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
  
  // Configure drain time for main phase
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_phase main_phase;

    super.end_of_elaboration_phase(phase);

    main_phase = phase.find_by_name("main", 0);
    main_phase.phase_done.set_drain_time(this, 100);
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
Both the driver and monitor execute reset_phase(), main_phase(), and post_main_phase().
In end_of_elaboration_phase(), the main runtime phase is obtained using find_by_name("main", 0).
set_drain_time(this, 100) adds a 100 time-unit delay after all objections in main_phase() are dropped.
post_main_phase() begins only after:
Every component finishes main_phase().
All objections are dropped.
The configured 100 time-unit drain time expires.

Execution timeline:

reset_phase
   ├── Driver (100)
   └── Monitor (150)
          ↓
main_phase
   ├── Driver (100)
   └── Monitor (200)
          ↓
100 time-unit drain time
          ↓
post_main_phase
   ├── Driver
   └── Monitor
