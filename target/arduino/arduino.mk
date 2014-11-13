#
# QkThings LICENSE
# The open source framework and modular platform for smart devices.
# Copyright (C) 2014 <http://qkthings.com>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

###############################################################################
# QkThings. Arduino Makefile
###############################################################################

CC      = $(TOOLCHAIN_DIR)/cpu/avr/linux/bin/avr-gcc
OBJCOPY = $(TOOLCHAIN_DIR)/cpu/avr/linux/bin/avr-objcopy
AR		= $(TOOLCHAIN_DIR)/cpu/avr/linux/bin/avr-ar
DUMP    = $(TOOLCHAIN_DIR)/cpu/avr/linux/bin/avr-objdump
PSIZE	= $(TOOLCHAIN_DIR)/cpu/avr/linux/bin/avr-size

OFORMAT = ihex

###############################################################################
# CPU
###############################################################################
#MCU = atmega328p
#F_CPU = 16000000

###############################################################################
# SOURCE
###############################################################################
INCLUDE_DIR += \
$(QKPROGRAM_DIR)/lib/hal/arduino

C_SRC_DIR += \
$(QKPROGRAM_DIR)/lib/hal/arduino
###############################################################################
# FLAGS
###############################################################################
BOOTLOADER_ADDRESS=1F800
CFLAGS += -mmcu=$(MCU) -DF_CPU=$(F_CPU) -ffunction-sections -fdata-sections
LDFLAGS = -Wl,--gc-sections $(CFLAGS) 
LDFLAGS += -Wl,-u,vfprintf -lprintf_min # enable printf
#LDFLAGS += -Wl,-u,vfprintf -lprintf_flt -lm # printf with floating point support
#CEXTRA = -Wa,-adhlns=$(<:.c=.lst)
#ASFLAGS = -Wa,-adhlns=$(<:.S=.lst),-gstabs
CFLAGS += -Wall -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -W -Wall -Wextra

###############################################################################
# AVRDUDE
###############################################################################
#PORT = COM19
#UPLOAD_RATE = 115200
AVRDUDE = $(TOOLCHAIN_DIR)/cpu/avr/linux/avrdude
AVRDUDE_CONF = $(TOOLCHAIN_DIR)/platform/arduino/common
AVRDUDE_PROGRAMMER = stk500
AVRDUDE_PORT = $(PORT)
AVRDUDE_WRITE_FLASH = -U flash:w:$(FILE):i
AVRDUDE_VERBOSE = -V#-v -v -v -v 
AVRDUDE_FLAGS = -C$(AVRDUDE_CONF)/avrdude.conf $(AVRDUDE_VERBOSE) -p$(MCU) -carduino -P$(PORT) -b$(UPLOAD_RATE) -D 

###############################################################################
# UPLOAD
###############################################################################
UPLOAD_CMD = $(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH)


