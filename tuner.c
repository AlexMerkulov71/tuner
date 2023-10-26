#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

// Function prototypes
void tune(double note_freq);
struct notes_freq scale();

// Structure to store note names and corresponding frequencies
struct notes_freq {
    char notes[37][3];
    double freqs[37];
};

int main() {
    // Generate the scale and store it in the 'x' variable
    struct notes_freq x = scale();

    // Print the note names and their corresponding frequencies
    for (int i = 0; i < 37; i++) {
        printf("%s: %.2f Hz\n", x.notes[i], x.freqs[i]);
    }

    // Call the 'tune' function with an example frequency
    tune(234.5);
    return 0;
}

void tune(double note_freq) {
    // Generate the scale and store it in the 'x' variable
    struct notes_freq x = scale();

    // Initialize variables to find the closest note
    double min_diff = fabs(note_freq - x.freqs[0]);
    int closest_note_index = 0;

    // Find the closest note in the scale
    for (int i = 1; i < 37; i++) {
        double diff = fabs(note_freq - x.freqs[i]);
        if (diff < min_diff) {
            min_diff = diff;
            closest_note_index = i;
        }
    }

    // Extract information about the closest note
    double closest_freq = x.freqs[closest_note_index];
    char* closest_note = x.notes[closest_note_index];
    char* direction;

    // Determine if the input frequency is flat, sharp, or in tune
    if (note_freq < (closest_freq * (pow(2.0, (-0.1 / 12.0))))) {
        direction = "flat";
    }
    else if (note_freq > (closest_freq * (pow(2.0, (0.1 / 12.0))))) {
        direction = "sharp";
    }
    else if (note_freq >= (closest_freq * (pow(2.0, (-0.1 / 12.0)))) && note_freq <= (closest_freq * (pow(2.0, (0.1 / 12.0))))) {
        direction = "in tune";
    }
    else { direction = ""; }

    // Define lower and upper frequency limits for determining "too low" or "too high"
    double lower_lim = x.freqs[0] * (pow(2.0, (-0.1 / 12.0)));
    double upper_lim = x.freqs[36] * (pow(2.0, (0.1 / 12.0)));

    // Check if the input frequency is too low, too high, or in tune
    if (note_freq < lower_lim) { printf("too low"); }
    else if (note_freq > upper_lim) { printf("too high"); }

    // Provide information about the closest note and its tuning
    else {
        printf("You are closest to the note %s. You are %s.\n", closest_note, direction);
    }
}

struct notes_freq scale() {
    // Initialize the 'music' structure to store note names and frequencies
    struct notes_freq music;

    // Define the basic note names without octaves
    char note_names[12][3] = { "A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#" };

    // Generate note names and their corresponding frequencies
    for (int i = 0; i < 37; i++) {
        strcpy(music.notes[i], note_names[i % 12]);
        music.freqs[i] = 55.00 * (pow(2.0, ((double)i / 12)));
    }
    return music;
}
