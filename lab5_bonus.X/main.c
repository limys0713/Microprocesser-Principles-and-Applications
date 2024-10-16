/*
 * File:   main.c
 * Author: User
 *
 * Created on October 18, 2023, 9:26 PM
 */


#include <xc.h>

extern unsigned int lcm(unsigned int a, unsigned int b);

void main(void) {
    volatile unsigned int ans_lcm = lcm(3, 15);
    while(1);
    return;
}
