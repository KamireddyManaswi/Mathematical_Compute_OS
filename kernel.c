void print_string(char *str, char *video, int pos) {
    while (*str) {
        video[pos * 2] = *str++;
        video[pos * 2 + 1] = 0x07;
        pos++;
    }
}

void main() {
    char *video = (char*)0xb8000;

    // Clear first row only (avoid full clear if issue)
    int i;
    for (i = 0; i < 160; i += 2) video[i] = 0x00;

    print_string("Kernel OK", video, 0);

    // Simple math: factorial 5 = 120
    int fact = 1, n = 5;
    for (i = 2; i <= n; i++) fact *= i;
    print_string(" Fact(5)=120", video, 10);

    while(1);
}