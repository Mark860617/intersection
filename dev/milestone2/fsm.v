
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

reg [2:0] current_state, next_state;

localparam  N_GREEN        = 3'd0,
            N_YELLOW       = 3'd1,
            RED_1          = 3'd2,
            E_LEFT         = 3'd3,
            E_GREEN        = 3'd4,
            E_YELLOW       = 3'd5,
            RED_2          = 3'd6,
            N_LEFT         = 3'd7;

always@(*)
begin: state_table
        case (current_state) // All states loop until they are told to go
            N_GREEN: next_state = go ? N_YELLOW : N_GREEN;
            N_YELLOW: next_state = counter10 ? RED_1: N_YELLOW;
            RED_1: next_state = counter5 ? E_LEFT: RED_1;
            E_LEFT: next_state = counter10 ? E_GREEN: E_LEFT;
            E_GREEN: next_state = counter5 ? E_YELLOW: E_GREEN;
            E_YELLOW: next_state = counter10 ? RED_2: E_YELLOW;
            RED_2: next_state = counter5 ? N_LEFT: RED_2;
            N_LEFT: next_state = counter10 ? N_GREEN: N_LEFT;
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
        RED_1: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b0;
          end
        E_LEFT: begin
            ledIn[0] = 1'b1;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b0;
          end
        E_GREEN: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b1;
          end
        E_YELLOW: begin
            ledIn[0] = 1'b1;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b1;
          end
        RED_2: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b1;
            ledIn[2] = 1'b1;
          end
        N_LEFT: begin
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
