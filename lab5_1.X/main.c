/*
 * File:   main.c
 * Author: User
 *
 * Created on October 17, 2023, 8:48 PM
 */


#include <xc.h>

extern unsigned char is_square(unsigned int a);

void main(void) {
    volatile unsigned char ans = is_square(9);
    while(1);
    return;
}
