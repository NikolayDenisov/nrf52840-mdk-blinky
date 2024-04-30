# Имя проекта
PROJECT_NAME     := blink_led
TARGET           := nrf52840_xxaa
OUTPUT_DIRECTORY := _build

# Пути
SDK_ROOT := /Users/nick/projects/iot/nRF5_SDK_17.1.0_ddde560
PROJ_DIR := /Users/nick/projects/iot/nrf52840-mdk-blinky

# Флаги оптимизации
OPT := -O3 -g3

# Параметры компиляции
CFLAGS += $(OPT)
CFLAGS += -mcpu=cortex-m4
CFLAGS += -mthumb -mabi=aapcs
CFLAGS += -Wall -Werror
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -DNRF52840_XXAA

# Параметры линковки
LDFLAGS += $(OPT)
LDFLAGS += -mthumb -mabi=aapcs -L$(SDK_ROOT)/modules/nrfx/mdk -Twfe_gcc_nrf52.ld
LDFLAGS += -mcpu=cortex-m4
LDFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
LDFLAGS += -Wl,--gc-sections
LDFLAGS += --specs=nano.specs

# Список исходных файлов
SRC_FILES += \
   $(SDK_ROOT)/modules/nrfx/mdk/gcc_startup_nrf52840.S \
   $(PROJ_DIR)/main.c \
   $(SDK_ROOT)/modules/nrfx/mdk/system_nrf52840.c

INC_FOLDERS += \
	-I $(SDK_ROOT)/modules/nrfx/mdk \
	-I $(SDK_ROOT)/components/toolchain/cmsis/include \
	-I $(PROJ_DIR)

# Добавление стандартных библиотек в конец списка библиотек
LIB_FILES += -lc -lnosys -lm

# Правило сборки
build: $(SRC_FILES)
	@echo "Creating build directory"
	mkdir -p $(OUTPUT_DIRECTORY)
	@$(MAKE) assembling
	@$(MAKE) compile_objects
	@$(MAKE) create_nrf52840_xxaa_in
	@$(MAKE) link_objects
	@$(MAKE) create_hex_file

assembling:
	@echo "Compiling assembly source files"
	"/Applications/ARM/bin/arm-none-eabi-gcc" -x assembler-with-cpp -MP -MD -c -o $(OUTPUT_DIRECTORY)/gcc_startup_nrf52840.S.o $(SDK_ROOT)/modules/nrfx/mdk/gcc_startup_nrf52840.S $(LDFLAGS) $(INC_FOLDERS)

# Компиляция объектных файлов
compile_objects:
	@echo "Compiling source files"
	$(foreach src_file,$(SRC_FILES),"/Applications/ARM/bin/arm-none-eabi-gcc" -std=c99 -MP -MD -c -o $(OUTPUT_DIRECTORY)/$(notdir $(src_file)).o $(src_file) $(CFLAGS) $(INC_FOLDERS);)

# Создание файла nrf52840_xxaa.in
create_nrf52840_xxaa_in:
	@echo "Creating nrf52840_xxaa.in file"
	find $(OUTPUT_DIRECTORY) -name "*.o" > $(OUTPUT_DIRECTORY)/nrf52840_xxaa.in

# Линковка объектных файлов
link_objects:
	@echo "Linking object files"
	"/Applications/ARM/bin/arm-none-eabi-gcc" $(LDFLAGS) @_build/nrf52840_xxaa.in -Wl,-Map=_build/nrf52840_xxaa.map -o _build/nrf52840_xxaa.out $(LIB_FILES)

# Создание .hex файла
create_hex_file:
	@echo "Creating binary .hex file from the .out file"
	"/Applications/ARM/bin/arm-none-eabi-objcopy" -O ihex $(OUTPUT_DIRECTORY)/$(TARGET).out $(OUTPUT_DIRECTORY)/$(TARGET).hex

# Очистка сборочных файлов
clean:
	@echo "Cleaning build files"
	rm -rf $(OUTPUT_DIRECTORY)

# Прошивка
flash:
	@echo "Flashing: $(OUTPUT_DIRECTORY)/$(TARGET).hex"
	pyocd flash -t nrf52840 $(OUTPUT_DIRECTORY)/$(TARGET).hex
