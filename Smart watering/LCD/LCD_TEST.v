`timescale 1ns / 1ps
module    LCD_TEST ( //Host Side
                    iCLK,iRST_N,
                    //LCD Side
                    LCD_DATA,LCD_RW,LCD_EN,LCD_RS,
					 Mostrar_10,
					 Mostrar_11,
					 Mostrar_12,
					 Mostrar_13,
					 Mostrar_14,
					 Mostrar_15,
					 Mostrar_16,
					 Mostrar_17,
					 Mostrar_18,
					 Mostrar_19,
					 Mostrar_110,
					 Mostrar_111,
					 Mostrar_112,
					 Mostrar_113,
					 Mostrar_114,
					 Mostrar_115,
					 Mostrar_20,
					 Mostrar_21,
					  Mostrar_22,
					  Mostrar_23,
					  Mostrar_24,
					  Mostrar_25,
					  Mostrar_26,
					  Mostrar_27,
					  Mostrar_28,
					  Mostrar_29,
					  Mostrar_210,
					  Mostrar_211,
					  Mostrar_212,
					  Mostrar_213,
					  Mostrar_214,
					  Mostrar_215
						  );
//Host Side
input  iCLK,iRST_N;

input [8:0] Mostrar_10;
input [8:0] Mostrar_11;
input [8:0] Mostrar_12;
input [8:0] Mostrar_13;
input [8:0] Mostrar_14;
input [8:0] Mostrar_15;
input [8:0] Mostrar_16;
input [8:0] Mostrar_17;
input [8:0] Mostrar_18;
input [8:0] Mostrar_19;
input [8:0] Mostrar_110;
input [8:0] Mostrar_111;
input [8:0] Mostrar_112;
input [8:0] Mostrar_113;
input [8:0] Mostrar_114;
input [8:0] Mostrar_115;
input [8:0] Mostrar_20;
input [8:0] Mostrar_21;
input [8:0] Mostrar_22;
input [8:0] Mostrar_23;
input [8:0] Mostrar_24;
input [8:0] Mostrar_25;
input [8:0] Mostrar_26;
input [8:0] Mostrar_27;
input [8:0] Mostrar_28;
input [8:0] Mostrar_29;
input [8:0] Mostrar_210;
input [8:0] Mostrar_211;
input [8:0] Mostrar_212;
input [8:0] Mostrar_213;
input [8:0] Mostrar_214;
input [8:0] Mostrar_215;

//LCD Side
output [7:0] LCD_DATA;
output LCD_RW,LCD_EN,LCD_RS;

//Internal Wires/Registers
reg [5:0]  LUT_INDEX;
reg [10:0]  LUT_DATA;
reg [5:0]  mLCD_ST;
reg [17:0] mDLY;
reg        mLCD_Start;
reg [7:0]  mLCD_DATA;
reg        mLCD_RS;
wire       mLCD_Done;

parameter    LCD_INTIAL  = 0;
parameter    LCD_LINE1   = 5;
parameter    LCD_CH_LINE = LCD_LINE1+16;
parameter    LCD_LINE2   = LCD_LINE1+16+1;
parameter    LUT_SIZE    = LCD_LINE1+32+30;

always@(posedge iCLK or negedge iRST_N)
begin
    if(!iRST_N)
    begin
        LUT_INDEX  <= 0;
        mLCD_ST    <= 0;
        mDLY       <= 0;
        mLCD_Start <= 0;
        mLCD_DATA  <= 0;
        mLCD_RS    <= 0;
    end
    else
    begin
        if(LUT_INDEX<LUT_SIZE)
        begin
            case(mLCD_ST)
            0:    begin
                    mLCD_DATA  <= LUT_DATA[7:0];
                    mLCD_RS    <= LUT_DATA[8];
                    mLCD_Start <= 1;
                    mLCD_ST    <= 1;
                end
            1:    begin
                    if(mLCD_Done)
                    begin
                    mLCD_Start <= 0;
                    mLCD_ST    <= 2;                    
                    end
                end
            2:    begin
                    if(mDLY<18'h8FFFF) // 5.2ms
                    mDLY <= mDLY+1;
                    else
                    begin
                       mDLY    <= 0;
                       mLCD_ST <= 3;
                    end
                end
            3:    begin
                    LUT_INDEX  <= LUT_INDEX+1;
                    mLCD_ST    <= 0;
                end
            endcase
        end else if (LUT_INDEX>=LUT_SIZE)begin
			LUT_INDEX<= 0;
		  end
    end
end

always@(*)
begin
    case(LUT_INDEX)
    //Initial
    LCD_INTIAL+0:    LUT_DATA    <=    9'h038; //Fun set
    LCD_INTIAL+1:    LUT_DATA    <=    9'h00C; //dis on
    LCD_INTIAL+2:    LUT_DATA    <=    9'h001; //clr dis
    LCD_INTIAL+3:    LUT_DATA    <=    9'h006; //Ent mode
    LCD_INTIAL+4:    LUT_DATA    <=    9'h080; //set ddram address
    //Line 1
    LCD_LINE1+0:     LUT_DATA    <=    Mostrar_10; 
    LCD_LINE1+1:     LUT_DATA    <=    Mostrar_11; 
    LCD_LINE1+2:     LUT_DATA    <=    Mostrar_12; 
    LCD_LINE1+3:     LUT_DATA    <=    Mostrar_13; 
    LCD_LINE1+4:     LUT_DATA    <=    Mostrar_14; 
    LCD_LINE1+5:     LUT_DATA    <=    Mostrar_15;  
    LCD_LINE1+6:     LUT_DATA    <=    Mostrar_16; 
    LCD_LINE1+7:     LUT_DATA    <=    Mostrar_17; 
    LCD_LINE1+8:     LUT_DATA    <=    Mostrar_18; 
    LCD_LINE1+9:     LUT_DATA    <=    Mostrar_19; 
    LCD_LINE1+10:    LUT_DATA    <=    Mostrar_110; 
    LCD_LINE1+11:    LUT_DATA    <=    Mostrar_111; 
    LCD_LINE1+12:    LUT_DATA    <=    Mostrar_112; 
    LCD_LINE1+13:    LUT_DATA    <=    Mostrar_113; 
    LCD_LINE1+14:    LUT_DATA    <=    Mostrar_114; 
    LCD_LINE1+15:    LUT_DATA    <=    Mostrar_115; 
    //Change Line
    LCD_CH_LINE:     LUT_DATA    <=    9'h0C0;
    //Line 2
    LCD_LINE2+0:     LUT_DATA    <=    Mostrar_20; 
    LCD_LINE2+1:     LUT_DATA    <=    Mostrar_21; 
    LCD_LINE2+2:     LUT_DATA    <=    Mostrar_22; 
    LCD_LINE2+3:     LUT_DATA    <=    Mostrar_23; 
    LCD_LINE2+4:     LUT_DATA    <=    Mostrar_24; 
    LCD_LINE2+5:     LUT_DATA    <=    Mostrar_25; 
    LCD_LINE2+6:     LUT_DATA    <=    Mostrar_26; 
    LCD_LINE2+7:     LUT_DATA    <=    Mostrar_27; 
    LCD_LINE2+8:     LUT_DATA    <=    Mostrar_28; 
    LCD_LINE2+9:     LUT_DATA    <=    Mostrar_29; 
    LCD_LINE2+10:    LUT_DATA    <=    Mostrar_210; 
    LCD_LINE2+11:    LUT_DATA    <=    Mostrar_211; 
    LCD_LINE2+12:    LUT_DATA    <=    Mostrar_212; 
    LCD_LINE2+13:    LUT_DATA    <=    Mostrar_213; 
    LCD_LINE2+14:    LUT_DATA    <=    Mostrar_214;
    LCD_LINE2+15:    LUT_DATA    <=    Mostrar_215;
    LCD_LINE2+16:    LUT_DATA    <=     9'h000; 
    LCD_LINE2+17:    LUT_DATA    <=    9'h000; 
    LCD_LINE2+18:    LUT_DATA    <=     9'h000; 
    LCD_LINE2+19:    LUT_DATA    <=     9'h000;
    LCD_LINE2+20:    LUT_DATA    <=    9'h000;
    LCD_LINE2+21:    LUT_DATA    <=     9'h000; 
    LCD_LINE2+22:    LUT_DATA    <=    9'h000; 
    LCD_LINE2+23:    LUT_DATA    <=     9'h000; 
    LCD_LINE2+24:    LUT_DATA    <=     9'h000;
    LCD_LINE2+25:    LUT_DATA    <=     9'h000; 
    LCD_LINE2+26:    LUT_DATA    <=    9'h000; 
    LCD_LINE2+27:    LUT_DATA    <=     9'h000; 
    LCD_LINE2+28:    LUT_DATA    <=     9'h000;
    LCD_LINE2+29:    LUT_DATA    <=    9'h000;
    LCD_LINE2+30:    LUT_DATA    <=     9'h000; 
    LCD_LINE2+31:    LUT_DATA    <=    9'h000; 
    LCD_LINE2+32:    LUT_DATA    <=     9'h000; 
    LCD_LINE2+33:    LUT_DATA    <=     9'h000;
    LCD_LINE2+34:    LUT_DATA    <=     9'h000; 
    LCD_LINE2+35:    LUT_DATA    <=    9'h000; 
    LCD_LINE2+36:    LUT_DATA    <=     9'h000; 
    LCD_LINE2+37:    LUT_DATA    <=     9'h000;
    LCD_LINE2+38:    LUT_DATA    <=    9'h000;
    LCD_LINE2+39:    LUT_DATA    <=     9'h000; 

    default:         LUT_DATA    <=    9'h000;
    endcase
end

LCD_Controller u0 ( //Host Side
                   .iDATA(mLCD_DATA),
                   .iRS(mLCD_RS),
                   .iStart(mLCD_Start),
                   .oDone(mLCD_Done),
                   .iCLK(iCLK),
                   .iRST_N(iRST_N),
                   //LCD Interface
                   .LCD_DATA(LCD_DATA),
                   .LCD_RW(LCD_RW),
                   .LCD_EN(LCD_EN),
                   .LCD_RS(LCD_RS)
						 );

endmodule 