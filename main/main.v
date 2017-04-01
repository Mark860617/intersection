module main(CLOCK_50, SW, KEY, GPIO_0, GP_OUT, GP_IN, LEDR);
input CLOCK_50;
input [9:0] SW;
input [0:0] KEY;
inout [35:0] GPIO_0;
input [30:0] GP_OUT;
output [4:0] GP_IN;
output[9:0] LEDR;

wire [2:0]led_cont;
wire [1:0] goController;
wire enable_next;

assign GPIO_0[30:0] = GP_OUT[30:0];
assign GP_IN[4:0] = {GPIO_0[35], 4'bzzzz};

//fsm lives in another file! Make sure to include fsm.v in the quartus project
fsm f0(
  .clk(CLOCK_50),
  .resetn(KEY[0]),
  .goControl(goController),
  .ledOut(led_cont)
  );

// The sensor input comes through port 20
//assign goController[0] = GPIO_0[20];
assign LEDR[0] = GP_IN[4];
assign LEDR[1] = led_cont[0];
assign LEDR[2] = led_cont[1];
assign LEDR[3] = led_cont[2];
assign goController[1] = SW[0];

led_control l0(
  .fsmIn(led_cont),
  .greenOut(GP_OUT[1:0]),
  .redOut(GP_OUT[3:2]),
  .yellowOut(GP_OUT[5:4]),
  .leftOut(GP_OUT[7:6])
  );

counter c0(
	.CLOCK_50(CLOCK_50),
	.enable(enable_next),
  );

 assign LEDR[4] = enable_next;

endmodule


module counter(CLOCK_50, enable);
	input CLOCK_50;
	output enable;
	wire enable_second_counter;
	counter1 u1(CLOCK_50, enable_second_counter);
	counter2 u2(enable_second_counter, enable);
endmodule

// counts 50mill posedges (1 second)
module counter1(clock, enable_next);

input clock;
output enable_next;

reg [25:0] count = 26'b0;
assign enable_next = (count == 26'b10111110101111000010000000) ? 1'b1 : 1'b0;

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
module counter2 (enable, enable_next);
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
