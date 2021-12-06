module MUX4to1 #(
parameter WIDTH = 32
)(
	input [WIDTH-1:0] a,
	input [WIDTH-1:0] b,
	input [WIDTH-1:0] c,
	input [WIDTH-1:0] d,
	input [1:0] selec,

   output reg [WIDTH-1:0] SrcB

);
always @(*)
begin
case (selec) 
	0: begin
		SrcB = a;
	end
	1: begin
		SrcB = b;
	end
	2: begin
		SrcB = c;
	end
	3: begin
		SrcB = d;
	end
endcase	
end
endmodule
