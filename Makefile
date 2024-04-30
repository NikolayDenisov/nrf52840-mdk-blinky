# Имя проекта
PROJECT_NAME     := blink_led
TARGET          := nrf52840_xxaa
OUTPUT_DIRECTORY := _build

# Путь к заголовочным
SDK_ROOT = /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560
PROJ_DIR = /Users/nick/projects/iot/nrf52840-mdk-blinky

# Optimization flags
OPT = -O3 -g3

# Параметры компиляции
CFLAGS += $(OPT)
CFLAGS += -mcpu=cortex-m4
CFLAGS += -mthumb -mabi=aapcs
CFLAGS += -Wall -Werror
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -DNRF52840_XXAA

# Linker flags
LDFLAGS += $(OPT)
LDFLAGS += -mthumb -mabi=aapcs -L/Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk -Twfe_gcc_nrf52.ld
LDFLAGS += -mcpu=cortex-m4
LDFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
# let linker dump unused sections
LDFLAGS += -Wl,--gc-sections
# use newlib in nano version
LDFLAGS += --specs=nano.specs

# Список исходных файлов
SRC_FILES += \
   /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk/gcc_startup_nrf52840.S \
   $(PROJ_DIR)/main.c \
   /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk/system_nrf52840.c

INC_FOLDERS += \
	-I /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk \
	-I /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/components/toolchain/cmsis/include \
	-I /Users/nick/projects/iot/nrf52840-mdk-blinky/

build: $(SRC_FILES) 
	@echo "Create build directories"
	mkdir -p $(OUTPUT_DIRECTORY)
	@echo Create object files from assembly source files
	"/Applications/ARM/bin/arm-none-eabi-gcc" -x assembler-with-cpp -MP -MD -c -o $(OUTPUT_DIRECTORY)/gcc_startup_nrf52840.S.o /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk/gcc_startup_nrf52840.S -g3 -mcpu=cortex-m4 -mthumb -mabi=aapcs -mfloat-abi=hard -mfpu=fpv4-sp-d16 -DAPP_TIMER_V2 -DAPP_TIMER_V2_RTC1_ENABLED -DBOARD_CUSTOM -DNRF52840_MDK -DBSP_UART_SUPPORT -DCONFIG_GPIO_AS_PINRESET -DFLOAT_ABI_HARD -DNRF52840_XXAA -D__HEAP_SIZE=8192 -D__STACK_SIZE=8192 $(INC_FOLDERS)
	@echo "Compiling"
	"/Applications/ARM/bin/arm-none-eabi-gcc" -std=c99 -MP -MD -c -o $(OUTPUT_DIRECTORY)/main.c.o /Users/nick/projects/iot/nrf52840-mdk-blinky/main.c $(CFLAGS) $(INC_FOLDERS)
	"/Applications/ARM/bin/arm-none-eabi-gcc" -std=c99 -MP -MD -c -o $(OUTPUT_DIRECTORY)/system_nrf52840.c.o /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk/system_nrf52840.c $(CFLAGS) $(INC_FOLDERS)
	@echo "Link object files"
	"/Applications/ARM/bin/arm-none-eabi-gcc" $(LDFLAGS) @_build/nrf52840_xxaa.in -Wl,-Map=_build/nrf52840_xxaa.map -o _build/nrf52840_xxaa.out
	@echo Create binary .bin file from the .out file
	'/Applications/ARM/bin/arm-none-eabi-objcopy' -O ihex $(OUTPUT_DIRECTORY)/$(TARGET).out $(OUTPUT_DIRECTORY)/$(TARGET).hex


clean:
	@echo "Очистка сборочных файлов"
	rm -rf $(OUTPUT_DIRECTORY)

flash:
	@echo Flashing: $(OUTPUT_DIRECTORY)/$(TARGET).hex
	pyocd flash -t nrf52840 $(OUTPUT_DIRECTORY)/$(TARGET).hex

