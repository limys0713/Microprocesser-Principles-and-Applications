/*
 * File:   main.c
 * Author: User
 *
 * Created on October 18, 2023, 1:19 AM
 */


#include <xc.h>

extern unsigned int multi_signed(unsigned char a, unsigned char b);

void main(void) {
    volatile unsigned int res = multi_signed(-30, 4);
    while(1);
    return;
}
