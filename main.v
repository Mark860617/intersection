module main(CLOCK_50, SW, KEY, GPIO_0, GP_OUT, GP_IN, LEDR);
input CLOCK_50;
input [9:0] SW;
input [0:0] KEY;
inout [35:0] GPIO_0;
input [30:0] GP_OUT;
ouput [4:0] GP_IN;
output[9:0] LEDR;

wire counter_en;
wire [2:0]led_cont;
wire [1:0] goController;

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

// Led control is basically the datapath
module led_control(fsmIn, greenOut, redOut, yellowOut, leftOut);
  input [2:0] fsmIn;

// The different lights of the intersection
  output reg [1:0] greenOut, redOut, yellowOut, leftOut;

// 0 bit represents the north / south road, 1 bit is the east / west road

  always @(*)
  begin
    case (fsmIn)
      3'd0: begin
        greenOut[0] = 1;
        redOut[0] = 0;
        yellowOut[0] = 0;
        leftOut[0] = 0;

        greenOut[1] = 0;
        redOut[1] = 1;
        yellowOut[1] = 0;
        leftOut[1] = 0;
      end
      3'd1: begin
        greenOut[0] = 0;
        redOut[0] = 0;
        yellowOut[0] = 1;
        leftOut[0] = 0;

        greenOut[1] = 0;
        redOut[1] = 1;
        yellowOut[1] = 0;
        leftOut[1] = 0;
      end
      3'd2: begin
        greenOut[0] = 0;
        redOut[0] = 1;
        yellowOut[0] = 0;
        leftOut[0] = 0;

        greenOut[1] = 0;
        redOut[1] = 1;
        yellowOut[1] = 0;
        leftOut[1] = 0;
      end
      3'd3: begin
        greenOut[0] = 0;
        redOut[0] = 1;
        yellowOut[0] = 0;
        leftOut[0] = 0;

        greenOut[1] = 0;
        redOut[1] = 1;
        yellowOut[1] = 0;
        leftOut[1] = 1;
      end
      3'd4: begin
        greenOut[0] = 0;
        redOut[0] = 1;
        yellowOut[0] = 0;
        leftOut[0] = 0;

        greenOut[1] = 1;
        redOut[1] = 0;
        yellowOut[1] = 0;
        leftOut[1] = 0;
      end
      3'd5: begin
        greenOut[0] = 0;
        redOut[0] = 1;
        yellowOut[0] = 0;
        leftOut[0] = 0;

        greenOut[1] = 0;
        redOut[1] = 0;
        yellowOut[1] = 1;
        leftOut[1] = 0;
      end
      3'd6: begin
        greenOut[0] = 0;
        redOut[0] = 1;
        yellowOut[0] = 0;
        leftOut[0] = 0;

        greenOut[1] = 0;
        redOut[1] = 1;
        yellowOut[1] = 0;
        leftOut[1] = 0;
      end
      3'd7: begin
        greenOut[0] = 0;
        redOut[0] = 1;
        yellowOut[0] = 0;
        leftOut[0] = 1;

        greenOut[1] = 0;
        redOut[1] = 1;
        yellowOut[1] = 0;
        leftOut[1] = 0;
      end
      default: begin
        greenOut[0] = 0;
        redOut[0] = 0;
        yellowOut[0] = 0;
        leftOut[0] = 0;

        greenOut[1] = 0;
        redOut[1] = 0;
        yellowOut[1] = 0;
        leftOut[1] = 0;
      end
    endcase
  end
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


// counts 10 seconds (50mill * 10 cycles )
module backup_counter(CLOCK_50, enable_next);

input CLOCK_50;
output enable_next;

reg [28:0] count = 29'b0;
assign enable_next = (count == 29'b11101110011010110010100000000) ? 1'b1 : 1'b0;

//short cycle for testing
// reg [4:0] count = 5'b0;
// assign enable_next = (count == 5'b11110) ? 1'b1 : 1'b0;


always @(posedge CLOCK_50)
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


module emergency(SW, its_an_emergency);
input [9:0] SW;
output its_an_emergency;

assign its_an_emergency = &SW[9:0];

endmodule
