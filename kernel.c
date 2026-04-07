void main() {
    volatile char *video = (volatile char*) 0xb8000;

    char msg[] = "Math OS Kernel Output: 5 + 3 = 8";

    int i = 0;
    while (msg[i] != '\0') {
        video[i * 2] = msg[i];
        video[i * 2 + 1] = 0x07;
        i++;
    }

    while (1);
}
