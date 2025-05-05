`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2023 08:48:21 PM
// Design Name: 
// Module Name: note_freq_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module note_tuner_TB();

    reg clk;
    reg on;
    real note;
    //wire [18:0] closest_freq;
    wire [3:0] closest_note;
    wire flat, sharp, in_tune;
    
    note_tuner DUT_note_tuner (.clk(clk), .note_in(note), .closest_note(closest_note), .flat(flat), .sharp(sharp), .in_tune(in_tune), .on(on));
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        
        clk = 0;
        on = 1;
        note = 0;
        
        #11 note = 355.789;
        #9;
        #11 note = 56.789;
        #10;
        #12 note = 440.050;
        #8;
        #7 on = 0;
        #5 note = 123.45;
        #13 on = 1;
        #50;
        $finish;
        
    end
endmodule
