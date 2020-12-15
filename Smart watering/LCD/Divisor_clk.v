
module Divisor_clk(
	input clk,
	output reg clkout
    );
reg [24:0] contador = 0;
parameter nciclos=25000000;
always @(posedge clk)begin
	contador<=contador+1;
	if(contador == nciclos) begin
		contador<=0;
		clkout <=~clkout;
	end
end

endmodule
