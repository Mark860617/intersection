module counter10s(CLOCK_50, enable);
	input CLOCK_50;
	output enable;
	wire enable_second_counter;
	counter1 u1(CLOCK_50, enable_second_counter);
	counter10pos u2(enable_second_counter, enable);
endmodule

module counter5s(CLOCK_50, enable);
  input CLOCK_50;
  output enable;

  wire enable_second_counter;
	counter1 u1(CLOCK_50, enable_second_counter);
  counter5pos u2(enable_second_counter, enable);
endmodule

// counts 50mill posedges (1 second)
module counter1(clock, enable_next);

input clock;
output enable_next;

reg [25:0] count = 26'b0;
assign enable_next = (count == 26'd50000000) ? 1'b1 : 1'b0;

//short cycle for testing
// reg [2:0] count = 2'b0;
// assign enable_next = (count == 3'b11) ? 1'b1 : 1'b0;


always @(posedge clock)
	begin
	if (enable_next == 1'b1)
		begin
			count <= 0;
		end
	else
		begin
			count <= count + 1'b1;
		end
	end
endmodule

// counts 10 posedges
module counter10pos (enable, enable_next);
input enable;
output enable_next;

reg [3:0] count = 4'b0;

assign enable_next = count[3] & ~count[2] & count[1] & ~count[0];  // 1010

always @(posedge enable)
	begin
		if (enable_next == 1'b1) begin
			count<=0;
		end
		else begin
			count <= count + 1'b1;
		end
	end
endmodule

// counts 5 posedges
module counter5pos (enable, enable_next);
input enable;
output enable_next;

reg [3:0] count = 4'b0;

assign enable_next = ~count[3] & count[2] & ~count[1] & count[0];  // 0101

always @(posedge enable)
	begin
		if (enable_next == 1'b1) begin
			count<=0;
		end
		else begin
			count <= count + 1'b1;
		end
	end
endmodule
