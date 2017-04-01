
// The FSM controls the 'go' signal for the FSM
// goControl is 2 bits: 0 bit is sensor, 1 bit is emergency
module fsm(clk, resetn, goControl, ledOut);
input clk, resetn;
input [1:0] goControl;
wire go;
wire [2:0] leds;
wire counterten;
wire counterfive;

output [2:0] ledOut;

control c0(
  .clk(clk),
  .go(go),
  .resetn(resetn),
  .counter10(counterten),
  .counter5(counterfive),
  .ledIn(leds)
  );

counter10s c10(
  .CLOCK_50(clk),
  .enable(counterten)
  );

counter5s c5(
  .CLOCK_50(clk),
  .enable(counterfive)
  );

  assign go = goControl[0] | goControl[1];

  /* Logic for the go operation based on sensor input */
  // always @ ( * ) begin
  //   case (goControl)
  //     2'b00: go = 1'b0;
  //     2'b01: go = 1'b1;
  //     2'b10: go = 1'b1;
  //     2'b11: go = 1'b1;
  //     default: go = 1'b0;
  //   endcase
  // end
assign ledOut = leds;
endmodule


// The actual FSM is contained in the 'control' module
module control(clk, go, resetn, counter10, counter5, ledIn);
input clk, go, resetn, counter10, counter5;
output reg [2:0] ledIn;

reg [3:0] current_state, next_state;

localparam  N_GREEN        = 4'd0,
            N_YELLOW       = 4'd1,
            WAIT_1         = 4'd2,
            RED_1          = 4'd3,
            WAIT_2         = 4'd4,
            E_LEFT         = 4'd5,
            WAIT_3         = 4'd6,
            E_GREEN        = 4'd7,
            WAIT_4         = 4'd8,
            E_YELLOW       = 4'd9,
            WAIT_5         = 4'd10,
            RED_2          = 4'd11,
            WAIT_6         = 4'd12,
            N_LEFT         = 4'd13,
            WAIT_7         = 4'd14;

always@(*)
begin: state_table
        case (current_state) // All states loop until they are told to go
            N_GREEN: next_state = go ? N_YELLOW : N_GREEN;
            N_YELLOW: next_state = counter10 ? WAIT_1: N_YELLOW;
            WAIT_1: next_state = ~counter10 ? RED_1 : WAIT_1;
            RED_1: next_state = counter5 ? WAIT_2: RED_1;
            WAIT_2: next_state = ~counter5 ? E_LEFT : WAIT_2;
            E_LEFT: next_state = counter10 ? WAIT_3: E_LEFT;
            WAIT_3: next_state = ~counter10 ? E_GREEN : WAIT_3;
            E_GREEN: next_state = counter5 ? WAIT_4: E_GREEN;
            WAIT_4: next_state = ~counter4 ? E_YELLOW: WAIT_4;
            E_YELLOW: next_state = counter10 ? WAIT_5: E_YELLOW;
            WAIT_5: next_state = ~counter10 ? RED_2: WAIT_5;
            RED_2: next_state = counter5 ? WAIT_6: RED_2;
            WAIT_6: next_state = ~counter5 ? N_LEFT: WAIT_6;
            N_LEFT: next_state = counter10 ? WAIT_7: N_LEFT;
            WAIT_7: next_state = ~counter10 ? N_GREEN: WAIT_7;
        default:     next_state = N_GREEN;
    endcase
end // state_table

always @(*)
begin: enable_signals
    // By default make all our signals 0
    ledIn[0] = 1'b0;
    ledIn[1] = 1'b0;
    ledIn[2] = 1'b0;

    case (current_state)
        N_GREEN: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
          end
        N_YELLOW: begin
            ledIn[0] = 1'b1;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
          end
        WAIT_1: begin
            ledIn[0] = 1'b1;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
          end
        RED_1: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b0;
          end
        WAIT_2: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b0;
          end
        E_LEFT: begin
            ledIn[0] = 1'b1;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b0;
          end
        WAIT_3: begin
            ledIn[0] = 1'b1;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b0;
          end
        E_GREEN: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b1;
          end
        WAIT_4: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b1;
          end
        E_YELLOW: begin
            ledIn[0] = 1'b1;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b1;
          end
        WAIT_5: begin
            ledIn[0] = 1'b1;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b1;
          end
        RED_2: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b1;
          end
        WAIT_6: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b1;
          end
        N_LEFT: begin
            ledIn[0] = 1'b1;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b1;
          end
        WAIT_7: begin
            ledIn[0] = 1'b1;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b1;
          end
    default: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
            end
    endcase
end // enable_signals

// current_state registers
always@(posedge clk)
begin: state_FFs
    if(!resetn)
        current_state <= N_GREEN;
    else
        current_state <= next_state;
end // state_FFS
endmodule
