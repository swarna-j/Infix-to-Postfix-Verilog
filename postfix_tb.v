`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
// Create Date:   16:43:50 03/10/2017
// Design Name:   postfix
// Module Name:   /home/jsk_027/Swarna/a2a/infix-postfix/postfix/postfix_tb.v
// Project Name:  postfix
// Target Device:  
// Tool versions:  
// Description: 
// Verilog Test Fixture created by ISE for module: postfix
// Dependencies:
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments:
////////////////////////////////////////////////////////////////////////////////

module postfix_tb;

	// Inputs
	reg [7:0] infix;
	reg clk;

	// Outputs
	wire [7:0] postfix;

	// Instantiate the Unit Under Test (UUT)
	postfix uut (
		.infix(infix), 
		.clk(clk), 
		.postfix(postfix)
	);

	initial begin
		// Initialize Inputs
		infix = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
      clk = 1;
	   #10 infix = "2";
		#10 infix = "*";
		#10 infix = "(";
		#10 infix = "3";		
		#10 infix = "+";		
		#10 infix = "1";
		#10 infix = ")";
		#10 infix = "%";
		#10 infix = "5";
		#10 infix = "+";
		#10 infix = "2";
		#10 infix = "=";
		// Add stimulus here

	end
   always #5 clk = ~clk;     
endmodule

