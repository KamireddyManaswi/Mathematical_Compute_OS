void main() {
    char *video = (char *)0xb8000;
    int i;

    // Clear screen (first 80*25*2 bytes)
    for (i = 0; i < 80*25*2; i++) {
        video[i] = (i == 1) ? ' ' : 0x00;  // Space char, black bg
    }

    // Print "Kernel OK" at row 0
    char *msg = "Kernel OK";
    for (i = 0; msg[i] != '\0'; i++) {
        video[(0*80 + i)*2] = msg[i];
        video[(0*80 + i)*2 + 1] = 0x07;  // Light grey on black
    }

    // Demo math calc: Simple pi approximation (Leibniz formula, 100k terms)
    double pi = 0.0;
    for (i = 0; i < 100000; i++) {
        pi += (i % 2 ? -1.0 : 1.0) / (2*i + 1);
    }
    pi *= 4;

    // Print pi approx at row 2 (rough ASCII, since no float print)
    char math_msg[] = "Pi approx: 3.14... (see calc)";
    for (i = 0; math_msg[i] != '\0'; i++) {
        video[(2*80 + i)*2] = math_msg[i];
        video[(2*80 + i)*2 + 1] = 0x07;
    }

    while (1);  // Halt
}