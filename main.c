#include "nrf52840.h"

// Определение пинов для светодиода
#define LED_PIN 23

// Функция для инициализации GPIO
void gpio_init() {
    // Включаем тактирование порта GPIO
    NRF_P0->DIRSET = (1UL << LED_PIN); // Настраиваем пин светодиода как выход
}

// Функция для включения светодиода
void led_off() {
    NRF_P0->OUTCLR = (1UL << LED_PIN); // Устанавливаем пин светодиода в логический 0 (включаем светодиод)
}

// Функция для выключения светодиода
void led_on() {
    NRF_P0->OUTSET = (1UL << LED_PIN); // Устанавливаем пин светодиода в логическую 1 (выключаем светодиод)
}

void nrf_delay() {
    for (volatile int i = 0; i < 5000000; ++i);
}

int main() {
    gpio_init(); // Инициализируем GPIO для управления светодиодом
    timer_init(); // Инициализируем таймер SysTick

    while(1) {
        led_on();
        nrf_delay();
        led_off();
        nrf_delay();
    }
}
