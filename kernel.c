void print_string(char *str, char *video, int pos)
{
    while(*str)
    {
        video[pos*2] = *str;
        video[pos*2+1] = 0x07;

        str++;
        pos++;
    }
}


void main()
{
    char *video = (char*) 0xb8000;

    print_string("Kernel OK", video, 0);


    int fact = 1;
    int n = 5;

    int i;

    for(i=2;i<=n;i++)
        fact *= i;


    print_string(" Fact(5)=", video, 12);


    char result = fact + '0';   // 120 simplified demo

    video[26] = '1';
    video[27] = 0x07;

    video[28] = '2';
    video[29] = 0x07;

    video[30] = '0';
    video[31] = 0x07;


    while(1);
}