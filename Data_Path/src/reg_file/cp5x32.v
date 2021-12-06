module cp5x32 
#( 
parameter WIDTH = 32, 
parameter SIZE = 5
)(
input [SIZE-1:0] entrada, //rd
output reg [WIDTH-1:0] salida
);
always @(*) begin 
case(entrada)
			default:	salida = 32'b00000000_00000000_00000000_00000000;
		5'b00001	:	salida = 32'b00000000_00000000_00000000_00000010;
		5'b00010	:	salida = 32'b00000000_00000000_00000000_00000100;
		5'b00011	:	salida = 32'b00000000_00000000_00000000_00001000;
		5'b00100	:	salida = 32'b00000000_00000000_00000000_00010000;
		5'b00101	:	salida = 32'b00000000_00000000_00000000_00100000;
		5'b00110	:	salida = 32'b00000000_00000000_00000000_01000000;
		5'b00111	:	salida = 32'b00000000_00000000_00000000_10000000;
		5'b01000	:	salida = 32'b00000000_00000000_00000001_00000000;
		5'b01001	:	salida = 32'b00000000_00000000_00000010_00000000;
		5'b01010	:	salida = 32'b00000000_00000000_00000100_00000000;
		5'b01011	:	salida = 32'b00000000_00000000_00001000_00000000;
		5'b01100	:	salida = 32'b00000000_00000000_00010000_00000000;
		5'b01101	:	salida = 32'b00000000_00000000_00100000_00000000;
		5'b01110	:	salida = 32'b00000000_00000000_01000000_00000000;
		5'b01111	:	salida = 32'b00000000_00000000_10000000_00000000;
		5'b10000	:	salida = 32'b00000000_00000001_00000000_00000000;
		5'b10001	:	salida = 32'b00000000_00000010_00000000_00000000;
		5'b10010	:	salida = 32'b00000000_00000100_00000000_00000000;
		5'b10011	:	salida = 32'b00000000_00001000_00000000_00000000;
		5'b10100	:	salida = 32'b00000000_00010000_00000000_00000000;
		5'b10101	:	salida = 32'b00000000_00100000_00000000_00000000;
		5'b10110	:	salida = 32'b00000000_01000000_00000000_00000000;
		5'b10111	:	salida = 32'b00000000_10000000_00000000_00000000;
		5'b11000	:	salida = 32'b00000001_00000000_00000000_00000000;
		5'b11001	:	salida = 32'b00000010_00000000_00000000_00000000;
		5'b11010	:	salida = 32'b00000100_00000000_00000000_00000000;
		5'b11011	:	salida = 32'b00001000_00000000_00000000_00000000;
		5'b11100	:	salida = 32'b00010000_00000000_00000000_00000000;
		5'b11101	:	salida = 32'b00100000_00000000_00000000_00000000;
		5'b11110	:	salida = 32'b01000000_00000000_00000000_00000000;
		5'b11111	:	salida = 32'b10000000_00000000_00000000_00000000;
	endcase
	end
endmodule

