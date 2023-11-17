`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2023 03:19:19 PM
// Design Name: 
// Module Name: note_freq
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


module note_tuner(
    input clk,
    input [18:0] note,
    output reg [18:0] closest_freq,
    output reg [3:0] closest_note,
    output reg flat,
    output reg sharp,
    output reg in_tune
);

    integer i = 6'b0;
    integer k = 6'b0;
    integer scale_factor = 10'b1111101000; // To keep the scale as a whole number
    integer base_freq = 6'b110111;
    integer min_diff;
    integer diff;
    integer closest_index;
    
    reg [18:0] freq_array [0:36];
    reg [3:0] note_array [0:36];
    
    always @* begin
        // Generate note names and their corresponding frequencies
        for (i = 0; i < 37; i = i + 1) begin
            // Calculate the frequency using fixed-point arithmetic
            freq_array[i] = $rtoi(base_freq * (2.0 ** (i/12.0)) * scale_factor);
            note_array[i] = i % 12;
        end
    end
    
    always @ (posedge clk) begin
        min_diff = note - freq_array[0];
        
        for (k = 0; k < 37; k = k + 1) begin
            diff = note - freq_array[k];
            
            if (diff < 0) begin
                diff = -1 * diff;  // Calculate absolute difference
            end
            
            if (diff < min_diff) begin
                min_diff = diff;
                closest_index = k;
            end
        end
        
        closest_freq = freq_array[closest_index];
        closest_note = note_array[closest_index];
        
        if (note < (closest_freq * 5000 /5029)) begin
            flat = 1;
            sharp = 0;
            in_tune = 0;
        end
        else if (note > (closest_freq * 5029 / 5000)) begin
            sharp = 1;
            flat = 0;
            in_tune = 0;
        end
        else begin
            in_tune = 1;
            flat = 0;
            sharp = 0;
        end
    end 
endmodule

