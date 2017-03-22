module counter(CLOCK_50, enable);
	input CLOCK_50;
	output enable;
	wire enable_second_counter;
	wire counted_10;
	counter1 u1(CLOCK_50, 1'b1, enable_second_counter);
	counter2 u2(enable_second_counter, counted_10);
	assign enable = counted_10;
endmodule

// count a second
module counter1(clock, enable, enable_next);

input clock;
input enable;
output enable_next;

reg [27:0] count = 28'b0;
assign enable_next = (val == 26'b10111110101111000010000000) ? 1'b1 : 1'b0;

// short cycle for testing
// reg [2:0] count = 3'b0;
// assign enable_next = (count == 3'b111) ? 1'b1 : 1'b0;

always @(posedge clock)
	begin
	if (enable == 0)
		count <= 0;
	else
		count <= count + 1'b1;
	end
endmodule

module counter2 (enable, enable_next);
input enable;
output enable_next;

reg [3:0] count = 4'b0;

assign enable_next = count[3] & ~count[2] & ~count[1] & count[0];  // 1001

always @(posedge enable)
	begin
		count <= count + 1'b1;
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

// Count 10 seconds


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
