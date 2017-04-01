// test connection of sensor
module sensor(GPIO_0, LEDR);
input [35:0] GPIO_0;
output [0:0] LEDR;

assign LEDR[0] = GPIO_0 [35];
endmodule