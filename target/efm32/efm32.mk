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
# qkthings
###############################################################################

# Requires:
# DEVICE
# BOARD
# TOOLCHAIN_DIR

###############################################################################
# MESSAGES
###############################################################################
ifneq ($(PRINT_MESSAGES),)
ifeq ($(HAS_BOOT),1)
    ${info Bootloader enabled}
else
    ${info Bootloader disabled}
endif
endif
###############################################################################
# DEFINITIONS
###############################################################################

###############################################################################
# DIRS and FILES
###############################################################################

ENERGYMICRO = $(TOOLCHAIN_DIR)/platform/efm32/common

#WINDOWSCS  ?= GNU Tools ARM Embedded\4.7 2013q1
#LINUXCS    ?= /home/mribeiro/gcc-arm-none-eabi-4_7-2013q1

TOOLDIR := $(TOOLCHAIN_DIR)/cpu/arm/win

GNU_INSTALL_ROOT = $(TOOLCHAIN_DIR)/cpu/arm/win/bin
GNU_PREFIX = arm-none-eabi-

INCLUDE_DIRS += \
$(ENERGYMICRO)/CMSIS/Include \
$(ENERGYMICRO)/emlib/inc

ifeq ($(FAMILY),)
$(error EFM32 FAMILY not defined)
endif

ifeq ($(FAMILY), EFM32G)
INCLUDE_DIRS += $(ENERGYMICRO)/Device/EnergyMicro/EFM32G/Include
C_SRC_FILES += $(ENERGYMICRO)/Device/EnergyMicro/EFM32G/Source/system_efm32g.c
S_SRC_FILES += $(ENERGYMICRO)/Device/EnergyMicro/EFM32G/Source/GCC/startup_efm32g.S
ifeq ($(HAS_BOOT),1)
LINKER_SCRIPT = $(ENERGYMICRO)/Device/EnergyMicro/EFM32G/Source/GCC/efm32g_boot.ld
else
LINKER_SCRIPT = $(ENERGYMICRO)/Device/EnergyMicro/EFM32G/Source/GCC/efm32g.ld
endif
endif

ifeq ($(FAMILY), EFM32TG)
INCLUDE_DIRS += $(ENERGYMICRO)/Device/EnergyMicro/EFM32TG/Include
C_SRC_FILES += $(ENERGYMICRO)/Device/EnergyMicro/EFM32TG/Source/system_efm32tg.c
S_SRC_FILES += $(ENERGYMICRO)/Device/EnergyMicro/EFM32TG/Source/GCC/startup_efm32tg.S
ifeq ($(HAS_BOOT),1)
LINKER_SCRIPT = $(ENERGYMICRO)/Device/EnergyMicro/EFM32TG/Source/GCC/efm32tg_boot.ld
else
LINKER_SCRIPT = $(ENERGYMICRO)/Device/EnergyMicro/EFM32TG/Source/GCC/efm32tg.ld$
endif
endif

###############################################################################
# FLAGS
###############################################################################

# -MMD : Don't generate dependencies on system header files.
# -MP  : Add phony targets, useful when a h-file is removed from a project.
# -MF  : Specify a file to write the dependencies to.
#DEPFLAGS = -MMD -MP -MF $(@:.o=.d)

# Add -Wa,-ahld=$(LST_DIR)/$(@F:.o=.lst) to CFLAGS to produce assembly list files
# -DDEBUG_EFM -DNDEBUG

CFLAGS += -mcpu=cortex-m3 -mthumb -mfix-cortex-m3-ldrd \
-ffunction-sections -fdata-sections -fomit-frame-pointer \
-funsigned-char -funsigned-bitfields -fshort-enums \
$(DEPFLAGS) \
-D$(DEVICE) -D$(BOARD) 

ASMFLAGS += -x assembler-with-cpp -mcpu=cortex-m3 -mthumb

# NOTE: The -Wl,--gc-sections flag may interfere with debugging using gdb.


#LDFLAGS += -Xlinker -Map=$(OBJ_DIR)/$(PROJECTNAME).map -mcpu=cortex-m3
#-specs=nano.specs -u _printf_float -u _scanf_float
LDFLAGS = -mcpu=cortex-m3 -mthumb \
-T$(LINKER_SCRIPT) \
-Wl,--gc-sections $(CFLAGS)

#LIBS += -Wl,--start-group -lstdc++ -lsupc++ -lc -lgcc -lnosys   -Wl,--end-group
#LIBS += -Wl,--start-group -lc -lgcc -lnosys  -Wl,--end-group
TARGET_LIBS += -Wl,--start-group -lc -lgcc -lnosys  -Wl,--end-group


###############################################################################
# UPLOAD
###############################################################################
#EFM32_LOADER=/home/$(USER)/qkthings_local/build/qt/efm32_loader/release/efm32_loader
#EFM32_LOADER="C:\Users\mribeiro\qkthings_local\build\qt\efm32_loader\release\efm32_loader.exe"
#EFM32_LOADER=/C/Users/Mario/qkthings_local/build/qt/efm32_loader/release/efm32_loader.exe
EFM32_LOADER=C:/Users/mribeiro/qkthings_local/build/qt/efm32_loader/release/efm32_loader.exe
ifeq  ($(BOOT_POL),)
$(error BOOT_POL not defined)
endif
#PORT ?= /dev/ttyUSB0
PORT ?= COM5
TRANSPORT ?= uart
UPLOAD_CMD = $(EFM32_LOADER) $(PORT) $(FILE) $(TRANSPORT) $(BOOT_POL)

