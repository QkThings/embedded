.SUFFIXES:
.PHONY: lib app clean upload

ifeq ($(MAKECMDGOALS),)
$(error Make what?)
endif

export OUTPUT_FILENAME

MAKEFILE_NAME := $(MAKEFILE_LIST)
MAKEFILE_DIR := $(dir $(MAKEFILE_NAME) ) 

ifeq ($(OS),Windows_NT)
#$(info WINDOWS)
OS_NAME = win
else
#$(info POSIX)
OS_NAME = posix
endif

MK = mkdir -p
RM = rm -rf

ifeq ($(VERBOSE), 1)
NO_ECHO :=
else
NO_ECHO := @
endif

TARGET_DIR = target
TOOLCHAIN_DIR = C:/Users/mribeiro/qkthings_local/toolchain
#TOOLCHAIN_DIR = C:\Users\mribeiro\qkthings_local\toolchain


GNU_INSTALL_ROOT = C:/MinGW/bin
GNU_PREFIX =


OUT_FORMAT = binary
OPTIMIZE = s

ARFLAGS = rcs

ifeq ($(MAKECMDGOALS), lib)
ifneq ($(LIB),)
$(info Builing LIB   = $(LIB))
else
$(error LIB must be defined)
endif
endif

ifeq ($(MAKECMDGOALS), app)
ifneq ($(APP),)
$(info Builing APP   = $(APP))
else
$(error APP must be defined)
endif
endif

ifneq ($(VERBOSE),)
$(info BUILD_DIR     = $(BUILD_DIR))
endif

ifneq ($(TARGET), )

ifneq ($(VERBOSE),)
$(info TOOLCHAIN_DIR = $(TOOLCHAIN_DIR))
$(info TARGET_DIR    = $(TARGET_DIR))
$(info TARGET        = $(TARGET))
endif

get_target_cpu = $(firstword $(subst ., ,$1))
get_target_board = $(or $(word 2,$(subst ., ,$1)),$(value 2))

TARGET_CPU=$(call get_target_cpu,$(TARGET))
TARGET_BOARD=$(call get_target_board,$(TARGET),$(TARGET_NAME))

#LIBS += -L"qkprogram/build/$(TARGET_CPU)/$(TARGET_BOARD)/device/lib" -lqkprogram
#LIBS += -L"qkperipheral/build/$(TARGET_CPU)/$(TARGET_BOARD)/lib" -lqkperipheral
#include qkperipheral/target/$(TARGET_CPU)/board/$(TARGET_BOARD).mk

include $(TARGET_DIR)/$(TARGET_CPU)/board/$(TARGET_BOARD).mk
include $(TARGET_DIR)/$(TARGET_CPU)/$(TARGET_CPU).mk

else
$(error TARGET must be defined)
endif

ifeq ($(MAKECMDGOALS),clean)
BUILD_DIR=$(CLEAN)
ifneq ($(APP), )
BUILD_DIR=$(APP)/build
else
ifneq ($(LIB), )
BUILD_DIR=$(LIB)/build
else
ifneq ($(CLEAN), )
BUILD_DIR=$(CLEAN)
else
$(error APP, LIB or CLEAN must be provided)
endif
endif
endif

else
ifeq ($(MAKECMDGOALS),lib)

include $(LIB)/lib.mk

BUILD_DIR=$(LIB)/build/$(LIB_BUILD_DIR)

INCLUDE_DIRS += \
$(LIB) \
$(addprefix $(LIB), $(LIB_INCLUDE_DIRS))

C_SRC_DIRS += \
$(LIB) \
$(addprefix $(LIB), $(LIB_C_SRC_DIRS))

else
ifeq ($(MAKECMDGOALS),app)

INCLUDE_DIRS += \
qkperipheral/include \
qkprogram/include

# IMPORTANT: Since qkprogram depends on qkperipheral, qkperipheral MUST be linked
# AFTER the qkprogram is
LIBS += -L"qkprogram/build/$(TARGET_CPU)/$(TARGET_BOARD)/device/lib" -lqkprogram
LIBS += -L"qkperipheral/build/$(TARGET_CPU)/$(TARGET_BOARD)/lib" -lqkperipheral
include qkperipheral/target/$(TARGET_CPU)/board/$(TARGET_BOARD).mk

PROJECT_NAME = app
BUILD_DIR = $(APP)/build

include $(APP)/app.mk

INCLUDE_DIRS += \
$(APP) \
$(addprefix $(APP), $(APP_INCLUDE_DIRS))

C_SRC_DIRS += \
$(APP) \
$(addprefix $(APP), $(APP_C_SRC_DIRS))

endif
endif
endif

LIBS += $(TARGET_LIBS)

OBJ_DIR = $(BUILD_DIR)/obj
LIB_DIR = $(BUILD_DIR)/lib
BIN_DIR = $(BUILD_DIR)/bin

BUILD_DIRS = $(BUILD_DIR) $(sort $(OBJ_DIR) $(BIN_DIR) $(LIB_DIR))

CC       		:= "$(GNU_INSTALL_ROOT)/$(GNU_PREFIX)gcc"
AS       		:= "$(GNU_INSTALL_ROOT)/$(GNU_PREFIX)as"
AR       		:= "$(GNU_INSTALL_ROOT)/$(GNU_PREFIX)ar"
LD       		:= "$(GNU_INSTALL_ROOT)/$(GNU_PREFIX)ld"
NM       		:= "$(GNU_INSTALL_ROOT)/$(GNU_PREFIX)nm"
OBJDUMP  		:= "$(GNU_INSTALL_ROOT)/$(GNU_PREFIX)objdump"
OBJCOPY  		:= "$(GNU_INSTALL_ROOT)/$(GNU_PREFIX)objcopy"
SIZE    		:= "$(GNU_INSTALL_ROOT)/$(GNU_PREFIX)size"


CFLAGS += -O$(OPTIMIZE) -g3 -Wall 
CFLAGS += -Werror-implicit-function-declaration 
CFLAGS += $(addprefix -D, $(DEFINES))

INCLUDEPATHS += $(addsuffix ", $(addprefix -I", $(INCLUDE_DIRS)))
C_SRC_FILES += $(wildcard $(addsuffix /*.c, $(C_SRC_DIRS)))

C_FILES = $(notdir $(C_SRC_FILES) )
S_FILES = $(notdir $(S_SRC_FILES) $(s_SRC_FILES) )
C_PATHS = $(sort $(dir $(C_SRC_FILES) ) )
S_PATHS = $(sort $(dir $(S_SRC_FILES) $(s_SRC_FILES) ) )
C_OBJS = $(addprefix $(OBJ_DIR)/, $(C_FILES:.c=.o))
C_DEPS = $(addprefix $(OBJ_DIR)/, $(C_FILES:.c=.d))
S_OBJS = $(if $(S_SRC_FILES), $(addprefix $(OBJ_DIR)/, $(S_FILES:.S=.o)))
s_OBJS = $(if $(s_SRC_FILES), $(addprefix $(OBJ_DIR)/, $(S_FILES:.s=.o)))
OBJS = $(C_OBJS) $(S_OBJS) $(s_OBJS)

vpath %.c $(C_PATHS)
vpath %.s $(s_PATHS)
vpath %.S $(S_PATHS)

# These prints are useful to debug Make errors (namely, "no rule to make target" errors)
#$(info C_FILES=$(C_FILES))
#$(info C_PATHS=$(C_PATHS))
#$(info OBJS=$(OBJS))

lib:	$(BUILD_DIRS) $(LIB_DIR)/lib$(PROJECT_NAME).a
app:	$(BUILD_DIRS) $(BIN_DIR)/$(PROJECT_NAME).bin

clean:
	$(RM) $(sort $(OBJ_DIR) $(BIN_DIR) $(LIB_DIR)) $(BUILD_DIR)

# Create build directories
$(BUILD_DIRS):
	$(NO_ECHO)$(MK) $@

# Create objects from C SRC files
$(OBJ_DIR)/%.o: %.c
	@echo Compiling $<
	$(NO_ECHO)$(CC) $(CFLAGS) $(INCLUDEPATHS) -c -o $@ $<

# Assemble .s/.S files
$(OBJ_DIR)/%.o: %.s
	@echo Assembling $<
	$(NO_ECHO)$(CC) $(ASMFLAGS) $(INCLUDEPATHS) -c -o $@ $<

$(OBJ_DIR)/%.o: %.S
	@echo Assembling $<
	$(NO_ECHO)$(CC) $(ASMFLAGS) $(INCLUDEPATHS) -c -o $@ $<

# Link
$(BIN_DIR)/$(PROJECT_NAME).out: $(OBJS)
	@echo Linking target: $@
	$(NO_ECHO)$(CC) $(LDFLAGS) $(INCLUDEPATHS) $(OBJS) $(LIBS) -o $(BIN_DIR)/$(PROJECT_NAME).out

# Create static library
$(LIB_DIR)/lib$(PROJECT_NAME).a: $(OBJS)
	@echo Creating static library: $@
	$(NO_ECHO)$(AR) $(ARFLAGS) $(LIB_DIR)/lib$(PROJECT_NAME).a $(OBJS)

# Create binary file
$(BIN_DIR)/$(PROJECT_NAME).bin: $(BIN_DIR)/$(PROJECT_NAME).out
	@echo Creating binary file
	$(OBJCOPY) -O $(OUT_FORMAT) $(BIN_DIR)/$(PROJECT_NAME).out $(BIN_DIR)/$(PROJECT_NAME).bin
	$(SIZE) $(BIN_DIR)/$(PROJECT_NAME).out
# Uncomment next line to produce assembly listing of entire program
#	$(DUMP) -h -S -C $(BIN_DIR)/$(PROJECT_NAME).out>$(LST_DIR)/$(PROJECT_NAME)out.lst

upload:
	$(NO_ECHO)$(UPLOAD_CMD)




