module emergency(SW, its_an_emergency);
input [9:0] SW;
output its_an_emergency;

assign its_an_emergency = &SW[9:0];

endmodule