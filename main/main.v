// Top level module for the whole project
module main(CLOCK_50, SW, KEY, GPIO_1, GPIO_0, LEDR, HEX0);
input CLOCK_50;
input [9:0] SW;
input [0:0] KEY;
input [35:0] GPIO_1;
output [35:0] GPIO_0;
output[9:0] LEDR;
output [6:0] HEX0;

wire [2:0]led_cont;
wire [1:0] goController;
wire [3:0] ramOutput;
wire enable_next;

fsm f0(
  .clk(CLOCK_50),
  .resetn(KEY[0]),
  .goControl(goController),
  .ledOut(led_cont)
  );

// The sensor input comes through port 1 of GPIO_1
assign goController[0] = ~GPIO_1[1] || ~GPIO_1[2];
assign LEDR[0] = ~GPIO_1[1];
assign LEDR[1] = ~GPIO_1[2];
assign goController[1] = SW[0];

led_control l0(
  .fsmIn(led_cont),
  .greenOut(GPIO_0[1:0]),
  .redOut(GPIO_0[3:2]),
  .yellowOut(GPIO_0[5:4]),
  .leftOut(GPIO_0[7:6])
  );

redlight r0(
  .clk(CLOCK_50),
  .resetn(KEY[0]),
  .fsmState(led_cont),
  .sensor(goController[0]),
  .ramOut(ramOutput[3:0])
  );

hex_decoder h0(
  .hex_digit(ramOutput[3:0]),
  .segments(HEX0[6:0])
  );

endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;

    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;
            default: segments = 7'h7f;
        endcase
endmodule
