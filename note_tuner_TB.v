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
    reg [18:0] note;
    wire [18:0] closest_freq;
    wire [3:0] closest_note;
    wire flat, sharp, in_tune;
    
    note_tuner DUT_note_tuner (.clk(clk), .note(note), .closest_freq(closest_freq), .closest_note(closest_note), .flat(flat), .sharp(sharp), .in_tune(in_tune));
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        
        clk = 0;
        note = 19'b0;
    
        #10 note = 355789;
        #10;
        #10 note = 56789;
        #10;
        #10 note = 440050;
        #50;
        $finish;
        
    end
endmodule
