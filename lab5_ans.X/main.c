/*
 * File:   main.c
 * Author: User
 *
 * Created on October 19, 2023, 12:59 PM
 */


#include <xc.h>

extern unsigned int lcm(unsigned int a, unsigned int b);

void main(void) {
    volatile unsigned int ans1 = lcm(40, 140);
    while(1);
    return;
}
