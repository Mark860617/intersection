module led_control(fsmIn, greenOut, redOut, yellowOut, leftOut);
input [3:0] fsmIn;
output [3:0] greenOut, redOut, yellowOut, leftOut;
// Lights for each intersection

always @(*)
begin
  case (fsmIn)
  
end
// North
light ng(
  .control(fsm),
  .lightOut(greenOut[0])
  );

light ny(
  .control(),
  .lightOut(yellowOut[0])
  );

light nr(
  .control(),
  .lightOut(redOut[0])
  );

light nl(
  .control(),
  .lightOut(leftOut[0])
  );

// South

light sg(
  .control(),
  .lightOut(greenOut[1])
  );

light sy(
  .control(),
  .lightOut(yellowOut[1])
  );

light sr(
  .control(),
  .lightOut(redOut[1])
  );

light sl(
  .control(),
  .lightOut(leftOut[1])
  );

// East

light eg(
  .control(),
  .lightOut(greenOut[2])
  );

light ey(
  .control(),
  .lightOut(yellowOut[2])
  );

light er(
  .control(),
  .lightOut(redOut[2])
  );

light el(
  .control(),
  .lightOut(leftOut[2])
  );

// West

light wg(
  .control(),
  .lightOut(greenOut[3])
  );

light wy(
  .control(),
  .lightOut(yellowOut[3])
  );

light wr(
  .control(),
  .lightOut(redOut[3])
  );

light wl(
  .control(),
  .lightOut(leftOut[3])
  );
endmodule

module light(control, lightOut);
  input control;
  output lightOut;

  assign lightOut = control;
endmodule
