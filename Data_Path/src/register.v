module register #(

parameter WHIDT = 32
)
(
		input		[WHIDT-1 : 0] d, 
		input 	clk, 
		input		reset, 
		output 	[WHIDT-1 : 0] q
);
		reg 		[WHIDT-1 : 0] q6;
		
   always @(posedge clk or negedge reset) begin
      if (!reset)
         q6 <= 0;
      else 
         q6 <= d;
   end
  assign q = q6;
endmodule
