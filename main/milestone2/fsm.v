module fsm(clk, go, counter, emergency, ledIn);
input clk, go, counter, emergency;
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
            N_YELLOW: next_state = go ? RED_1: N_YELLOW;
            RED_1: next_state = go ? E_LEFT: RED_1;
            E_LEFT: next_state = go ? E_GREEN: E_LEFT;
            E_GREEN: next_state = go ? E_YELLOW: E_GREEN;
            E_YELLOW: next_state = go ? RED_2: E_YELLOW;
            RED_2: next_state = go ? N_LEFT: RED_2;
            N_LEFT: next_state = go ? N_GREEN: N_LEFT;
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
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
          end
        RED_1: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
          end
        E_LEFT: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
          end
        E_GREEN: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
          end
        E_YELLOW: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
          end
        RED_2: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
          end
        N_LEFT: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
            end
    default: begin
            ledIn[0] = 1'b0;
            ledIn[1] = 1'b0;
            ledIn[2] = 1'b0;
            end
    endcase
end // enable_signals
endmodule
