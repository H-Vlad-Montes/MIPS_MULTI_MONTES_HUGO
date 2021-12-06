module data_path #(
	parameter WIDTH = 32
)(
	input clk, 
	input reset,
		//inputs to control unit
	input ALUSrcA,		
	input	[2:0]ALUControl,
	input [1:0]ALUSrcB,
	input PC_enable,  
	input IorD,			
	input MemWrite,	
	input IRWrite,		
	input RegDst,		
	input MemtoReg,	
	input RegWrite,	
	input PCSrc,		
	
	output zero,
	
	output [5:0] op,  //opcode
	output [5:0]Funct,	//funct
	output [7:0]GPIO,
	
	// output displays
	
	output [WIDTH-1:0] ffwd_disp,
	output [WIDTH-1:0] ffrd_disp,
	output [WIDTH-1:0] RD1_disp,
	output [WIDTH-1:0] RD2_disp,
	output [WIDTH-1:0] SrcB_disp

);
	wire [WIDTH-1:0] in_PC;
	wire [WIDTH-1:0] ffpc_o;
	wire [WIDTH-1:0] ffrd_o;
	wire [WIDTH-1:0] ffwd_o;
	wire [WIDTH-1:0] MUX2X1_1_o;
	wire [WIDTH-1:0] WD3_i;
	wire [WIDTH-1:0] ReadData_o;
	wire [4:0] A3_o;					// rd
	
	wire zero_1;
	
	wire [WIDTH-1:0] ALUResult;
	wire [WIDTH-1:0] ALU_o;

	wire [WIDTH-1:0] RD1_i;
	wire [WIDTH-1:0] RD2_i;
	
	wire [WIDTH-1:0] RD1_o;
	wire [WIDTH-1:0] RD2_o;

	wire  [4:0] rs_A1;
	wire  [4:0] rt_A2;
	wire  [4:0] rd_A3;
	wire	[WIDTH-1:0] SrcA;
	wire	[WIDTH-1:0] SrcB;
	
	wire [15:0] sign_extend_i;
	
	wire	[WIDTH-1:0] sign_extend_o;
	
	assign rs_A1 = ffrd_o [25:21];
	assign rt_A2 = ffrd_o [20:16];
	assign rd_A3 = ffrd_o [15:11];
	
	assign op [5:0] = ffrd_o [31:26];
	assign Funct [5:0] = ffrd_o [5:0];
	
	assign sign_extend_i = ffrd_o [15:0];
	assign zero = zero_1;
	assign GPIO [7:0] = ALUResult [7:0];
	
	// assign monitores 
	
	assign ffrd_disp [WIDTH-1:0] = ffrd_o [WIDTH-1:0];
	assign ffwd_disp [WIDTH-1:0] = ffwd_o [WIDTH-1:0];
	
	assign RD1_disp [WIDTH-1:0] = RD1_o [WIDTH-1:0];
	assign RD2_disp [WIDTH-1:0] = RD2_o [WIDTH-1:0];
	assign SrcB_disp [WIDTH-1:0] = SrcB [WIDTH-1:0];

	registro_pc PC (
	.d(in_PC), 					//input
	.clk(clk),
	.reset(reset),
	.enable(PC_enable),
	.q(ffpc_o)					//output
	);
	
	mux2to1 first( 
	.x(ffpc_o), 
	.y(ALU_o), 
	.Sel(IorD),
	.Data_out(MUX2X1_1_o)
	);
	
	memory_system_wrapper data_memory(
	.while_enable_i(MemWrite),		//enable
	.write_data(RD2_o), 				//escritura
	.address_i(MUX2X1_1_o),			//Address
	.clk(clk),							//clk
	.ReadData(ReadData_o)			//output
	);
	
	ff RD (								//Instr****** primer registro del rd
	.d(ReadData_o), 					//input
	.clk(clk),
	.reset(reset),
	.enable(IRWrite),
	.q(ffrd_o)							//output
	);
	
	register RD_WD3 (					//Data******* segundo registro del rd 
	.d(ReadData_o), 					//input
	.clk(clk),
	.reset(reset),
	.q(ffwd_o)							//output
	);
	
	mux2to1 RD_WD3_1( 
	.x(ALU_o), 
	.y(ffwd_o), 
	.Sel(MemtoReg),
	.Data_out(WD3_i)
	);
	
	mux2to1
	#(.DATA_WIDTH(5)) A3( 
	.x(rt_A2), 
	.y(rd_A3), 
	.Sel(RegDst),
	.Data_out(A3_o)
	);
	
	wrapper_register_file reg_file(
	.clk(clk),
	.reset(reset),
	.reg_write_WE3_i(RegWrite), 		//enable
	.read_register_A1_i(rs_A1), 	//rs
	.read_register_A2_i(rt_A2), 	//rt
	.write_register_A3_i(A3_o),	// rd
	.write_data_WD3_i(WD3_i),		// R[rd]
   .read_data_RD1_o(RD1_i),		//R[rs]
	.read_data_RD2_o(RD2_i) 		//R[rt]

);
	register RD1_A (
	.d(RD1_i), 					//input
	.clk(clk),
	.reset(reset),
	.q(RD1_o)					//output ***********salida a monitor 
	);
	
	mux2to1 RD1_A_1( 
	.x(ffpc_o), 
	.y(RD1_o), 
	.Sel(ALUSrcA),
	.Data_out(SrcA)					//SrcA input to ALU
	);
	
	register RD2_B (
	.d(RD2_i), 					//input
	.clk(clk),
	.reset(reset),
	.q(RD2_o)					//output SrcB input to MUX4to1_00************salida a monitor
	);
	
	sign_extend Signlmm(
	.sign_ext_i(sign_extend_i),
	.sign_ext_o(sign_extend_o)
	);

	
	MUX4to1 Src(
	.a(RD2_o),   
	.b(32'h4),						
	.c(sign_extend_o),
	.d(sign_extend_o << 2),
	.selec(ALUSrcB),
   .SrcB(SrcB)					//output to monitor 
	);
	
	 ALU ALUC(
	.select(ALUControl),
	.a(SrcA),
	.b(SrcB),
	.zero(zero_1),
	.y(ALUResult)
	);
	
	register ALUR (
	.d(ALUResult), 			//input
	.clk(clk),
	.reset(reset),
	.q(ALU_o)					//output SrcB input to MUX4to1_00
	);
	
	mux2to1 ALU_result( 
	.x(ALUResult), 
	.y(ALU_o), 
	.Sel(PCSrc),
	.Data_out(in_PC)					//SrcA input to ALU
	);
	
endmodule
