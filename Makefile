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

# Список исходных файлов
SRC_FILES += \
   $(PROJ_DIR)/main.c \

INC_FOLDERS += \
	-I /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk \
	-I /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/components/toolchain/cmsis/include \
	-I /Users/nick/projects/iot/nrf52840-mdk-blinky/ \

# Create build directories
$(OUTPUT_DIRECTORY):
	@echo "Create build directories"
	mkdir -p $@
	cd $(OUTPUT_DIRECTORY) && mkdir $(TARGET)
	'/Applications/ARM/bin/arm-none-eabi-gcc' -x assembler-with-cpp -MP -MD -c -o _build/nrf52840_xxaa/gcc_startup_nrf52840.S.o /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk/gcc_startup_nrf52840.S -g3 -mcpu=cortex-m4 -mthumb -mabi=aapcs -mfloat-abi=hard -mfpu=fpv4-sp-d16 -DAPP_TIMER_V2 -DAPP_TIMER_V2_RTC1_ENABLED -DBOARD_CUSTOM -DNRF52840_MDK -DBSP_UART_SUPPORT -DCONFIG_GPIO_AS_PINRESET -DFLOAT_ABI_HARD -DNRF52840_XXAA -D__HEAP_SIZE=8192 -D__STACK_SIZE=8192 $(INC_FOLDERS)
	'/Applications/ARM/bin/arm-none-eabi-gcc' -std=c99 -MP -MD -c -o $(OUTPUT_DIRECTORY)/$(TARGET)/main.c.o /Users/nick/projects/iot/nrf52840-mdk-blinky/main.c $(CFLAGS) $(INC_FOLDERS)
	"/Library/Developer/CommandLineTools/usr/bin/make" -s --no-print-directory -f "/Users/nick/projects/iot//nRF5_SDK_17.1.0_ddde560//components/toolchain/gcc/dump.mk" VARIABLE=CONTENT_TO_DUMP > $(OUTPUT_DIRECTORY)/nrf52840_xxaa.in
	'/Applications/ARM/bin/arm-none-eabi-gcc' -O3 -g3 -mthumb -mabi=aapcs -L /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk -T /Users/nick/projects/iot/nrf52840-mdk-blinky/wfe_gcc_nrf52.ld -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -Wl,--gc-sections --specs=nano.specs $(OUTPUT_DIRECTORY)/nrf52840_xxaa.in -Wl,-Map=$(OUTPUT_DIRECTORY)/nrf52840_xxaa.map -o $(OUTPUT_DIRECTORY)/nrf52840_xxaa.out
	'/Applications/ARM/bin/arm-none-eabi-objcopy' -O ihex $(OUTPUT_DIRECTORY)/nrf52840_xxaa.out $(OUTPUT_DIRECTORY)/nrf52840_xxaa.hex

all:
	@echo "Compiling"

%.c.o:
	@echo "Create object files from C source files"
	'/Applications/ARM/bin/arm-none-eabi-gcc' -std=c99 -MP -MD -c -o $(OUTPUT_DIRECTORY)/$(TARGET)/main.c.o /Users/nick/projects/iot/nrf52840-mdk-blinky/main.c $(CFLAGS) -I /Users/nick/projects/iot/nrf52840-mdk-blinky/

%.out:
	@echo "Link object files"
	"/Library/Developer/CommandLineTools/usr/bin/make" -s --no-print-directory -f "/Users/nick/projects/iot//nRF5_SDK_17.1.0_ddde560//components/toolchain/gcc/dump.mk" VARIABLE=CONTENT_TO_DUMP > $(OUTPUT_DIRECTORY)/nrf52840_xxaa.in
	'/Applications/ARM/bin/arm-none-eabi-gcc' -O3 -g3 -mthumb -mabi=aapcs -L /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk -L /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk/nrf_common.ld -T $(PROJ_DIR)/wfe_gcc_nrf52.ld -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -Wl,--gc-sections --specs=nano.specs $(OUTPUT_DIRECTORY)/nrf52840_xxaa.in -Wl,-Map=$(OUTPUT_DIRECTORY)/nrf52840_xxaa.map -o $(OUTPUT_DIRECTORY)/nrf52840_xxaa.out


%.bin: %.out
	@echo Create binary .bin file from the .out file
	'/Applications/ARM/bin/arm-none-eabi-objcopy' -O ihex $(OUTPUT_DIRECTORY)/nrf52840_xxaa.out $(OUTPUT_DIRECTORY)/nrf52840_xxaa.hex

%.S.o %.s.o.o:
	@echo Create object files from assembly source files
	'/Applications/ARM/bin/arm-none-eabi-gcc' -x assembler-with-cpp -MP -MD -c -o _build/nrf52840_xxaa/gcc_startup_nrf52840.S.o /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560/modules/nrfx/mdk/gcc_startup_nrf52840.S -g3 -mcpu=cortex-m4 -mthumb -mabi=aapcs -mfloat-abi=hard -mfpu=fpv4-sp-d16 -DAPP_TIMER_V2 -DAPP_TIMER_V2_RTC1_ENABLED -DBOARD_CUSTOM -DNRF52840_MDK -DBSP_UART_SUPPORT -DCONFIG_GPIO_AS_PINRESET -DFLOAT_ABI_HARD -DNRF52840_XXAA -D__HEAP_SIZE=8192 -D__STACK_SIZE=8192 $(INC_FOLDERS)

clean:
	@echo "Очистка сборочных файлов"
	rm -rf $(OUTPUT_DIRECTORY)


flash: default
	@echo Flashing: $(OUTPUT_DIRECTORY)/nrf52840_xxaa.hex
	pyocd flash -t nrf52840 $(OUTPUT_DIRECTORY)/nrf52840_xxaa.hex


# Default target - first one defined
default: all