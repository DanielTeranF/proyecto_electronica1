
module Riego(input Clk,


			  
/////////////VALVULA////////////////////
            //output servo,
////////////////////////////////////////


/////////////TEMPORIZADOR///////////////
				//input reset,
				//input start,
				//output reg [3:0] deci_seg, u_seg, d_seg,
////////////////////////////////////////

////////////////LCD/////////////////////
				inout [7:0] LCD_DATA,      
				output LCD_RW,        
				output LCD_EN,        
				output LCD_RS,  
////////////////////////////////////////		

///////////////ELECTROVALVULA////////////////
				output reg EV,
////////////////////////////////////////

//////////////Sensor de luz ////////////
				input SL,
				output reg LED0, //D4
////////////////////////////////////////
//////////////Sensor de humedad ////////////
				input SH,
				output reg LED1,//D7
				output reg LED2,//D10
				output reg LED3, //D13
				output reg LED4 // D14 Tiempo de apertura de la electroválvula
////////////////////////////////////////
);
			  
reg [5:0]message;
reg [1:0] status;
reg [22:0] counter; 
wire seg;
reg LED_status = 1'b1;
reg status_EV = 1'b0;

reg [30:0]contador;

initial begin

contador = 0;

end


	//temporizador_top temporizador(Clk,tiempo_establecido,reset,pause,alarma,SSeg,an);
	LCD_Top lcd(.mensaje(message),.CLOCK_50(Clk),.LCD_RW(LCD_RW),.LCD_EN(LCD_EN),.LCD_RS(LCD_RS),.LCD_DATA(LCD_DATA));
	//divftempo div1(.clock(clk),.reset(reset),.start(start),.seg(seg));

/////////////////////////////////////////////////////	
/////////////////MAQUINA DE ESTADOS//////////////////
/////////////////////////////////////////////////////

always @(*) begin  // Control de los estados y mensajes

if(SL ==1'b0 && SH == 1'b0) begin message <=0; status<=INIT; LED0 = !LED_status; LED1 = LED_status; LED2 = LED_status; LED3 = LED_status; end

else if(SL == 1'b1 && SH == 1'b0) begin message <=1;  status<=INIT; LED0 = LED_status; LED1 = !LED_status; LED2 = LED_status; LED3 = LED_status; end

else if(SL == 1'b0 && SH == 1'b1) begin message <=2;  status<=END; LED0 = LED_status; LED1 = LED_status; LED2 = !LED_status; LED3 = LED_status;  end

else if(SL == 1'b1 && SH == 1'b1) begin message <=3; status<=INIT; LED0 = LED_status; LED1 = LED_status; LED2 = LED_status; LED3 = !LED_status; end

else begin message <=4; end

end

parameter INIT=0, END=1; //END --> apertura, INIT --> estado inicial

always @ (posedge Clk)begin //Activar contador

case(status)
		INIT: begin
			contador <=0;
			EV = status_EV;
			LED4 = LED_status;
		end

		END: begin // contador
			if(contador <= 30'd750_000_000) begin EV = !status_EV; contador <= contador + 1; LED4 = !LED_status; end
			else begin EV = status_EV;  LED4 = LED_status; end
		end

endcase

end


endmodule
