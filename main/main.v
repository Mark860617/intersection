// Top level module for the whole project
module main(CLOCK_50, SW, KEY, GPIO_1, GPIO_0, LEDR);
input CLOCK_50;
input [9:0] SW;
input [0:0] KEY;
input [35:0] GPIO_1;
output [35:0] GPIO_0;
output[9:0] LEDR;

wire [2:0]led_cont;
wire [1:0] goController;
wire enable_next;

fsm f0(
  .clk(CLOCK_50),
  .resetn(KEY[0]),
  .goControl(goController),
  .ledOut(led_cont)
  );

// The sensor input comes through port 1 of GPIO_1
assign goController[0] = GPIO_1[1] | GPIO_1[2];
assign LEDR[0] = GPIO_1[1];
assign LEDR[1] = GPIO_1[2];
assign goController[1] = SW[0];

led_control l0(
  .fsmIn(led_cont),
  .greenOut(GPIO_0[1:0]),
  .redOut(GPIO_0[3:2]),
  .yellowOut(GPIO_0[5:4]),
  .leftOut(GPIO_0[7:6])
  );

endmodule
