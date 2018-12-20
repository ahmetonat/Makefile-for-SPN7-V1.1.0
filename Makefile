
#The Makefile for using SPN7 with GNU ARM Embedded.
# The mark '~/' means the root directory of 'X-CUBE-SPN7' library installation.
# See: https://github.com/ahmetonat/Makefile-for-SPN7-V1.1.0/blob/master/README.md for details.

# The locations of the files within SPN7 are shown as comments above them:

# ~/Projects/Multi/Examples/MotorControl/SW4STM32/startup_stm32f302x8.s
STARTUP = startup_stm32f302x8.s

# ~/Projects/Multi/Examples/MotorControl/Src/
SOURCES= main_F302.c
SOURCES += system_stm32f3xx.c
SOURCES += stm32F302_nucleo_ihm07m1.c
SOURCES += stm32f3xx_it.c

# ~/Drivers/BSP/X-NUCLEO-IHM07M1/X-NUCLEO-IHM07M1.c
SOURCES += X-NUCLEO-IHM07M1.c
# ~/Middlewares/ST/MC_6Step_Lib/Src/6Step_Lib.c
SOURCES += 6Step_Lib.c
# ~/Drivers/BSP/Components/l6230/l6230.c
SOURCES += l6230.c

# ~/Drivers/STM32F3xx_HAL_Driver/Src/stm32f3xx_hal_XXXX.c
SOURCES += stm32f3xx_hal_gpio.c
SOURCES += stm32f3xx_hal_dma.c
SOURCES += stm32f3xx_hal_cortex.c
SOURCES += stm32f3xx_hal.c
SOURCES += stm32f3xx_hal_uart.c
SOURCES += stm32f3xx_hal_uart_ex.c
SOURCES += stm32f3xx_hal_usart.c
SOURCES += stm32f3xx_hal_msp.c
SOURCES += stm32f3xx_hal_tim.c
SOURCES += stm32f3xx_hal_tim_ex.c
SOURCES += stm32f3xx_hal_adc.c
SOURCES += stm32f3xx_hal_adc_ex.c
SOURCES += stm32f3xx_hal_dac.c
SOURCES += stm32f3xx_hal_dac_ex.c
SOURCES += stm32f3xx_hal_rcc.c
SOURCES += stm32f3xx_hal_rcc_ex.c

#SOURCES += math.c
#SOURCES += stdlib.c
#SOURCES += stdio.c


#Generate object file names by auto substituting files with .c suffix to
# files with .o suffix:
OBJS= $(SOURCES:.c=.o)

#Define the name of the output  files to be the same as the name of the
# current directory:
DIRNAME=$(notdir $(CURDIR))

# Most importantly, the '.bin' file will be burned into the processor:
BIN_FILE=$(DIRNAME).bin

# Declare the names of output binary files. ELF is the default type output:
ELF_FILE=$(DIRNAME).elf

# Map file shows where each function and variable are allocated in memory:
MAP_FILE=$(DIRNAME).map

# The linker script for STM32F302X8_FLASH defines the memory locations, amounts etc.:
# ~/Drivers/CMSIS/Device/ST/STM32F3xx/Source/Templates/gcc/linker/STM32F302X8_FLASH.ld
LDSCRIPT = STM32F302X8_FLASH.ld
#Important: Add the following line to STM32F302X8_FLASH.ld:
# PROVIDE (_exit = _ebss);


#Processor type from 
PTYPE = STM32F302x8 

# --------------------------------------------------
# Path to Programs (Or, where to find the programs):
# Path to the device programer software.:
# IMPORTANT! Change this to suit your own computer.
#STLINK_PATH=See if this will be necessary:STM32 ST-LINK Utility\ST-LINK Utility

# Tools (Path to the compiler etc.):
#TOOLROOT=
#CC=$(TOOLROOT)\arm-none-eabi-gcc
#LD=$(TOOLROOT)\arm-none-eabi-gcc
#AR=$(TOOLROOT)\arm-none-eabi-ar
#AS=$(TOOLROOT)\arm-none-eabi-as
#OBJCOPY=$(TOOLROOT)\arm-none-eabi-objcopy

CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
OBJCOPY=arm-none-eabi-objcopy

# Library path "updated for f302"
LIBROOT=/home/onat/elektronik/ARM/Compiler/STM32CubeExpansion_SPN7_V1.1.0

DEVICE=$(LIBROOT)/Drivers/CMSIS/Device/ST/STM32F3xx/Include
CORE=$(LIBROOT)/Drivers/CMSIS/Include
PERIPH=$(LIBROOT)/Drivers/STM32F3xx_HAL_Driver

# Search path for peripheral library
vpath %.c $(CORE)
vpath %.c $(PERIPH)/Src
vpath %.c $(DEVICE)


# The following C Flag allows variable declaration in the middle of code:
#$ arm-none-eabi-gcc --specs=nosys.specs


#--------------------------------------------------
# Compilation Flags (These pass information to the compiler about 
#                    how we want the project to be compiled.)

CFLAGS  = -O1 -g
CFLAGS+= -mcpu=cortex-m4 -mthumb 
# Next line tells where to search for header files (Include:I) 
CFLAGS+= -I$(DEVICE) -I$(CORE) -I$(PERIPH)/Inc -I.
CFLAGS+= -D$(PTYPE) -DUSE_STDPERIPH_DRIVER -std=gnu11 
# -std=gnull used for for variable declarations within code.

ASFLAGS = -g 

LDFLAGS = -T./STM32F302X8_FLASH.ld 

LDFLAGS+= -mthumb -mcpu=cortex-m4 -Wl,-Map=$(MAP_FILE)

OBJCOPYFLAGS = -O binary



# The files with the .d suffix tell the compiler to generate file dependencies:
#  If a file depends on a depended file, and the depended file is modified, then
#   the dependent file must also be re-compiled. This allows make to compile the
#   project in an intelligent manner. 
-include $(OBJS:.o=.d)


#-----------------------------------------------------
# From this point onwards, we describe make how to compile files,
#   either based on explicit name, or by filename extension.
#   e.g., how to compile a .c file to a .o file. 

$(BIN_FILE) : $(ELF_FILE)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@	

$(ELF_FILE) : $(OBJS) $(STARTUP)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(STARTUP) $(LDLIBS) $(LDFLAGS_POST)

# Compile each .o file from the list at the top from each .c file.
# Also generate dependency info (.d file)
%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@
	$(CC) -MM $(CFLAGS) $< > $*.d

%.o: %.s
	$(CC) -c $(CFLAGS) $< -o $@

# This part executes when we write the command "make clean"
clean:
	rm $(OBJS) $(OBJS:.o=.d) $(ELF_FILE) $(MAP_FILE) 

# This part executes when we write the command "make flash"
# For JTAG debugger:
jflash: $(BIN_FILE)
	st-flash  write $(BIN_FILE)  0x8000000

# For serial port programming:
sflash: $(BIN_FILE)
	stm32flash -w $(BIN_FILE) -b230400 -v -g0x0  /dev/ttyUSB0

debug: $(ELF_FILE)
	arm-none-eabi-gdb $(ELF_FILE)



