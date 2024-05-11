#include "nrf52840.h"

#define LED_PIN 22

void gpio_init() {
    // Write: a '1' sets pin to output; a '0' has no effect
    // In [2]: bin(1 << 23)
    //Out[2]: '0b100000000000000000000000'
    NRF_P0->DIRSET = (1UL << LED_PIN);
}

void led_on() {
    // Write: a '1' sets the pin low; a '0' has no effect
    NRF_P0->OUTCLR = (1UL << LED_PIN);
}

void led_off() {
    // Write: a '1' sets the pin high; a '0' has no effect
    NRF_P0->OUTSET = (1UL << LED_PIN);
}

void nrf_delay() {
    for (int i = 0; i < 5000000; ++i);
}

int main() {
    gpio_init();
    while(1) {
        led_on();
        nrf_delay();
        led_off();
        nrf_delay();
    }
}

