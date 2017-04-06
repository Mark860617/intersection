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
