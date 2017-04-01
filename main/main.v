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
