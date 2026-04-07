void main() {
    char *video = (char*) 0xb8000;

    char msg[] = "Kernel Working! 5+3=8";

    int i = 0;
    while (msg[i]) {
        video[i*2] = msg[i];
        video[i*2+1] = 0x07;
        i++;
    }

    while(1);
}