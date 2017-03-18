`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Nanyang Technological University
// Engineer: Swarna Kamakshi Jayaraman
// Create Date: 00:42:48 03/10/2017 
// Design Name: Infix to Postfix conversion
// Module Name: postfix 
// Project Name: Algorithms to Architectures Lab Report 2
// Target Devices: 
// Tool versions: 
// Description: Convert infix notation to postfix notation
// Dependencies: None 
// Revision: 0.01
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module postfix(input [7:0]infix,
					input clk,
					output reg [7:0]postfix);

reg [7:0]in_val[0:50];
reg [7:0]out_val[0:50];
reg [7:0]stack[0:50];
reg [7:0] ch;
reg [7:0] temp;
reg [7:0] op1, op2;
reg [3:0] top = 3'b0;
reg [1:0] ch_pr;
reg [1:0] stacktop_pr;
reg [1:0] ret_val = 2'bZ;
reg [1:0] k = 2'b0;
reg done = 1'b0;

integer i = 0;
integer j = 0;
integer l = 0;

parameter  INIT = 1,
	   GET_INPUT = 2,
	   POP_VAL = 3,
	   CHECK_PRECEDENCE = 4,
	   COMPARE_PRECEDENCE = 5,
	   EMPTY_STACK = 6,
	   EVALUATE = 7;

reg [3:0] p_s = 3'b0;
reg [3:0] n_s = INIT; 

always @ (infix)
begin
	if (infix != "\0")
	begin
	  in_val[l] = infix;
	  l = l + 1;	
	end
	if (infix == "=")
	begin				
		done = 1;
		l = 0;
	end	
end	

always@(posedge clk)
begin 
   if(done == 1)
	begin
	p_s = n_s;
	case(p_s)
		INIT: 
		begin		  		 
        stack[top] = "#" ;
		  n_s = GET_INPUT;
		end
		GET_INPUT: 
		begin
		   if(in_val[i] != "=")
			begin
				ch = in_val[i];
				if(ch == "(") 
				begin										
					top = top+1;
					stack[top] = ch;
					i = i+1; 
					n_s = GET_INPUT; 
				end
				else if (in_val[i] >= "0" && in_val[i] <= "9") 
				begin
					out_val[j] = ch;
					j = j + 1;
					i = i+1; 
					n_s = GET_INPUT; 
				end
				else if(in_val[i] == ")")
				begin
				   n_s = POP_VAL;
				end
				else
				begin
				   n_s = CHECK_PRECEDENCE;
				end				
			end
			else
			begin
			   n_s = EMPTY_STACK; //pop from stack till empty			
			end
		end
		POP_VAL:
		begin
				if(stack[top] != "(")
				begin
					out_val[j] = stack[top];
					top = top-1;
					j = j+1;
	            n_s = POP_VAL;
				end
				else
				begin					
					top = top-1; //pop out "("
					i = i+1; 				
					n_s = GET_INPUT;
				end								
		end
		CHECK_PRECEDENCE:
		begin
			 if(k <=1)
			 begin
				 if(k == 0)
					temp = stack[top];
				 else
					temp = ch;
				
				 case(temp)
					"#": ret_val = 'b00;	 
					"(": ret_val = 'b01;	  
					"+": ret_val = 'b10;	  	  
					"-": ret_val = 'b10;
					"*": ret_val = 'b11;
					"%": ret_val = 'b11;
				 endcase	
				 
				 if(k == 0)
					stacktop_pr = ret_val;
				 else
					ch_pr = ret_val;
					
				 k = k+1;
				 n_s = CHECK_PRECEDENCE;
			end
			else
			begin
				k = 0;
				n_s = COMPARE_PRECEDENCE;
			end
		end
		COMPARE_PRECEDENCE:
		begin
			if(stacktop_pr >= ch_pr)
		   begin
				out_val[j] = stack[top];
				top = top-1;				
				j = j+1;
				n_s = CHECK_PRECEDENCE;
		  end
		  else
		  begin				
				top = top+1;
				stack[top] = ch;
				i = i+1;				
				n_s = GET_INPUT;								
		  end	
		end	
		EMPTY_STACK:
		begin
		  if(stack[top] != "#")     // Pop from stack till empty 
		  begin
				out_val[j] = stack[top];
				top = top-1;
				j = j+1;
				n_s = EMPTY_STACK; 
		  end
		  else
		  begin		
				i = 0;
				n_s = EVALUATE;
				top=0;
		  end
		end
		EVALUATE:
		begin
			if(i< j)
			begin
			  if(out_val[i] >= "0" && out_val[i] <= "9")
			  begin
			    top = top+1;				 
				 stack[top] = out_val[i];
			  end
			  else 
			  begin
			    op1 = stack[top] - 48;
				 top = top-1;
				 op2 = stack[top] - 48;
				 case(out_val[i])
					 "+": ch = op1 + op2;
					 "-": ch = op2 - op1;
					 "*": ch = op1 * op2;
					 "%": ch = op2 % op1;
				 endcase
				 stack[top] = ch + 48;				 
			  end
			 i = i+1;
			  n_s = EVALUATE;
		end
		else
		begin
		     postfix = stack[top];
		end
	end
	
  endcase		
end
end
endmodule
