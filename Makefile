TARGET = main

BUILD_DIR = build

PREFIX = arm-none-eabi-
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size

MCU = -mcpu=cortex-m3 -mthumb

C_DEFS = -DSTM32F103xB

C_INCLUDES = \
-CMSIS/ARM \
-CMSIS/STM32F1xx/Include \
-modules/Include

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) -O0 -Wall -fdata-sections -ffunction-sections -g -gdwarf-2

LDSCRIPT = STM32F103XB_FLASH.ld
LDFLAGS = $(MCU) -T$(LDSCRIPT) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--gcc-sections --specs=nano.specs

C_SOURCES = \
-src/main.c \
-CMSIS/STM32F1xx/Source/system_stm32f1xx.c \
-modules/Source/PWM.c \
-modules/Source/User.c

ASM_SOURCES = \
-CMSIS/STM32F1xx/Source/startup_stm32f103xb.s

OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

$(BUILD_DIR)/%.o: %.c | $(BUILD_DIR)
		$(CC) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.s | $(BUILD_DIR)
		$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) | $(BUILD_DIR)
		$(CC) $(OBJECTS) $(LDFLAGS) -o $@
		$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf
		$(CP) -O ihex $< $@

$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf
		$(CP) -O binary -S $< $@

$(BUILD_DIR):
		mkdir $@

clean:
		rm -rf $(BUILD_DIR)