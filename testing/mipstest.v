//------------------------------------------------
// mipstest.v
// David_Harris@hmc.edu 23 October 2005
// Testbench for MIPS processor
//------------------------------------------------

module testbench;

  reg         clk;
  reg         reset;

  wire [31:0] writedata, dataadr;
  wire memwrite;

  // instantiate device to be tested
  top dut(clk, reset, writedata, dataadr, memwrite);
  
  integer currentTest;
  integer numTests;
  integer successfulTests;
  reg currentSuccess;
  
  reg [31:0] counter;
  
  always@(posedge clk)
      counter <= counter + 1;
  
  // initialize test
  initial
    begin
      counter <= 0;
      successfulTests = 0;
      numTests = 4;
      // Be sure to keep timing synced with imem's memory loads
      for(currentTest = 0; currentTest < numTests; 
          currentTest = currentTest + 1) begin
        currentSuccess <= 0;
        reset <= 1; # 15; reset <= 0;
        # 1985;
        if(currentSuccess) begin
          $display("Simulation %d succeeded %d", currentTest, counter);
          successfulTests = successfulTests + 1;
        end else begin
          $display("Simulation %d failed %d", currentTest, counter);
        end
      end
      $display("Test complete -- %d out of %d passed", successfulTests, 
        numTests);
      $stop;
    end
  
  // generate clock to sequence tests
  always
    begin
      clk <= 1; # 5; clk <= 0; # 5;
    end

  // check results
  always@(negedge clk)
    begin
      case (currentTest)
        0:
          if(memwrite) begin
            if(dataadr === 18 & writedata === 21) begin
              currentSuccess <= 1;
            end else begin
              $display("Writing value %d to address %h", writedata, dataadr);
            end
          end
        1:
          if(memwrite) begin
            if(dataadr === 84 & writedata === 7) begin
              currentSuccess <= 1;
            end else begin
              $display("Writing value %d to address %h", writedata, dataadr);
            end
          end
        2:
          if(memwrite) begin
            if(dataadr === 32'h70f00ff0 & writedata === 2) begin
              currentSuccess <= 1;
            end else begin
              $display("Writing value %d to address %h", writedata, dataadr);
            end
          end
        3:
          if(memwrite) begin
            if(dataadr === 32'h8f0ff00d & writedata === 2) begin
              currentSuccess <= 1;
            end else begin
              $display("Writing value %d to address %h", writedata, dataadr);
            end
          end
//        default:
      endcase
    end
endmodule



