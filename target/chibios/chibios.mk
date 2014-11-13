

TOOLDIR := $(TOOLCHAIN_DIR)/linux/arm/gcc

CC      = $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-gcc$(QUOTE)
LD      = $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-ld$(QUOTE)
AR      = $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-ar$(QUOTE)
OBJCOPY = $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-objcopy$(QUOTE)
DUMP    = $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-objdump$(QUOTE)
PSIZE	= $(QUOTE)$(TOOLDIR)/bin/arm-none-eabi-size$(QUOTE)


INCLUDE_DIR += \
$(PORTINC) $(KERNINC) $(TESTINC) \
$(HALINC) $(PLATFORMINC) $(BOARDINC) $(LWINC) \
$(CHIBIOS)/os/various

C_SRC_DIR += \
$(PORTSRC) \
$(KERNSRC) \
$(HALSRC) \
$(PLATFORMSRC) \
$(BOARDSRC)

S_SRC += \
$(PORTASM)
