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
    input clk, on,                  // 'clk' for clock signal, 'on' as an enable signal
    input [63:0] note_in,           // 64-bit input representing the musical note frequency
    // output reg [18:0] closest_freq, // 19-bit output for closest frequency (not used)
    output reg [3:0] closest_note,  // 4-bit output for the closest note index
    output reg flat,                // Output signal indicating if the note is flat
    output reg sharp,               // Output signal indicating if the note is sharp
    output reg in_tune              // Output signal indicating if the note is in tune
);
    // Variable declarations
    integer i, k, min_diff, diff, closest_index; // Loop counters and variables for calculation
    wire [18:0] note = note_in * 1000;           // Scale the input note frequency
    
    // Frequency related variables
    reg [5:0] BASE_FREQ;             // Base frequency for calculation
    reg [18:0] freq_lookup [0:36];   // Array to hold predefined equation constants
    reg [18:0] closest_freq;         // Variable to store the frequency closest to input
    reg [18:0] freq_array [0:36];    // Array to store calculated frequencies
    reg [3:0] note_array [0:36];     // Array to store semitone index
    
    // Initialise values when 'on' is high
    always @ (posedge on) begin  
    
        BASE_FREQ = 55; // Base frequency set to 55 Hz
        // Initialise equation constants
        freq_lookup[0] = 1000;
        freq_lookup[1] = 1059;
        freq_lookup[2] = 1122;
        freq_lookup[3] = 1189;
        freq_lookup[4] = 1260;
        freq_lookup[5] = 1335;
        freq_lookup[6] = 1414;
        freq_lookup[7] = 1498;
        freq_lookup[8] = 1587;
        freq_lookup[9] = 1682;
        freq_lookup[10] = 1782;
        freq_lookup[11] = 1888;
        freq_lookup[12] = 2000;
        freq_lookup[13] = 2119;
        freq_lookup[14] = 2245;
        freq_lookup[15] = 2378;
        freq_lookup[16] = 2520;
        freq_lookup[17] = 2670;
        freq_lookup[18] = 2828;
        freq_lookup[19] = 2997;
        freq_lookup[20] = 3175;
        freq_lookup[21] = 3364;
        freq_lookup[22] = 3564;
        freq_lookup[23] = 3775;
        freq_lookup[24] = 4000;
        freq_lookup[25] = 4238;
        freq_lookup[26] = 4490;
        freq_lookup[27] = 4757;
        freq_lookup[28] = 5040;
        freq_lookup[29] = 5339;
        freq_lookup[30] = 5657;
        freq_lookup[31] = 5993;
        freq_lookup[32] = 6350;
        freq_lookup[33] = 6727;
        freq_lookup[34] = 7127;
        freq_lookup[35] = 7551;
        freq_lookup[36] = 8000;
    
    end

    // Main logic triggered on the positive edge of the clock
    always @ (posedge clk) begin
        if (on) begin
            // Loop to generate frequencies and corresponding note names
            for (i = 0; i < 37; i = i + 1) begin
                freq_array[i] = freq_lookup[i] * BASE_FREQ; // Calculate frequency
                note_array[i] = i % 12;                     // Determine semitone index
            end
        
            // Determine the closest frequency to the input note
            min_diff = note - freq_array[0];
            for (k = 0; k < 37; k = k + 1) begin
                diff = note - freq_array[k];  // Calculate difference
                if (diff < 0) begin
                    diff = -diff;  // Absolute value of difference
                end
                
                // Update the closest frequency and its index
                if (diff < min_diff) begin
                    min_diff = diff;
                    closest_index = k;
                end
            end
            
            // Set outputs based on closest frequency
            closest_freq = freq_array[closest_index];
            closest_note = note_array[closest_index];
            
            // Check if the note is flat, sharp, or in tune
            if ((note < (closest_freq * 5000 / 5029)) || (note == 0)) begin
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
        end else begin
            // Reset outputs if the module is not enabled
            closest_note = 0;
            flat = 0;
            sharp = 0;
            in_tune = 0;
        end
    end
endmodule

