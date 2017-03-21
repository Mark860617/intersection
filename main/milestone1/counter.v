module counter(SW, CLOCK_50, HEX0);
input CLOCK_50;
input [1:0]SW;
output [6:0] HEX0;
wire enable;
wire [27:0]count1;
wire [3:0]count2;
counter1 u0(CLOCK_50, enable, count1[27:0]);
selector u1(SW[1:0], CLOCK_50, enable, count1[27:0]);
counter2 u2(enable, CLOCK_50, count2[3:0]);
displayHEX u3(count2[3:0],HEX0);

endmodule

//Counter 1 to count 26 bits

module counter1(clock, enable, count1);


input clock;
input enable;
output [27:0] count1;
reg [27:0]out = 27'b0;
assign count1[27:0] = out [27:0];
always @(posedge clock)
	begin
	if (enable == 1)
		out <= 0;
	else
		out <= out + 1'b1;
	end
endmodule

//Module 2: Cases to choose the type of output

module selector(select, clock, enable, count1);
input [1:0] select;
input clock;
input [27:0]count1;
output enable;
reg out = 1'b0;
assign enable = out;
always @(posedge clock)
	begin
		if (out == 1)
			out = 0;
		else
			case (select)
			2'b00: out = (count1 >= 1'b1)? 1'b1 : 1'b0;
			2'b01: out = (count1 >= 28'd50000000)? 1'b1:1'b0;
			2'b10: out = (count1 >= 28'd100000000)? 1'b1:1'b0;
			2'b11: out = (count1 >= 28'd200000000)? 1'b1:1'b0;
			default: out = 1'b0;
			endcase
		end
endmodule

//Counter 2 for 4 bits

module counter2 (enable, clock, count2);

input enable;
input clock;
output [3:0] count2;
reg [3:0]out = 4'b0;
assign count2[3:0] = out;
always @(posedge clock)
	begin
		if (enable == 1)
			out <= out + 1'b1;
	end

endmodule

//HEX Module
module displayHEX (s,h);

input[3:0] s;
output[6:0] h;

//Lights, the Not is for the purpose of the keys since 0 represents pressed
assign h[0] = ~((s[3]|s[2]|s[1]|~s[0])&(s[3]|~s[2]|s[1]|s[0])&(~s[3]|s[2]|~s[1]|~s[0])&(~s[3]|~s[2]|s[1]|~s[0]));
assign h[1] = ~((s[3]|~s[2]|s[1]|~s[0])&(s[3]|~s[2]|~s[1]|s[0])&(~s[3]|s[2]|~s[1]|~s[0])&(~s[3]|~s[2]|s[1]|s[0])&(~s[3]|~s[2]|~s[1]|s[0])&(~s[3]|~s[2]|~s[1]|~s[0]));
assign h[2] = ~((s[3]|s[2]|~s[1]|s[0])&(~s[3]|~s[2]|s[1]|s[0])&(~s[3]|~s[2]|~s[1]|s[0])&(~s[3]|~s[2]|~s[1]|~s[0]));
assign h[3] = ~((s[3]|s[2]|s[1]|~s[0])&(s[3]|~s[2]|s[1]|s[0])&(s[3]|~s[2]|~s[1]|~s[0])&(~s[3]|s[2]|s[1]|~s[0])&(~s[3]|~s[2]|~s[1]|~s[0])&(~s[3]|s[2]|~s[1]|s[0]));
assign h[4] = ~((s[3]|s[2]|s[1]|~s[0])&(s[3]|s[2]|~s[1]|~s[0])&(s[3]|~s[2]|s[1]|s[0])&(s[3]|~s[2]|s[1]|~s[0])&(s[3]|~s[2]|~s[1]|~s[0])&(~s[3]|s[2]|s[1]|~s[0]));
assign h[5] = ~((s[3]|s[2]|s[1]|~s[0])&(s[3]|s[2]|~s[1]|s[0])&(s[3]|s[2]|~s[1]|~s[0])&(s[3]|~s[2]|~s[1]|~s[0])&(~s[3]|~s[2]|s[1]|~s[0]));
assign h[6] = ~((s[3]|s[2]|s[1]|s[0])&(s[3]|s[2]|s[1]|~s[0])&(s[3]|~s[2]|~s[1]|~s[0])&(~s[3]|~s[2]|s[1]|s[0]));

endmodule
