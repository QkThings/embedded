# From: (CHIBIOS)/os/ports/GCC/ARMCMx/rules.mk

# Compiler options
OPT = $(USE_OPT)
COPT = $(USE_COPT)
CPPOPT = $(USE_CPPOPT)

# Garbage collection
ifeq ($(USE_LINK_GC),yes)
  OPT += -ffunction-sections -fdata-sections -fno-common
  LDOPT := ,--gc-sections
else
  LDOPT :=
endif

# Linker extra options
ifneq ($(USE_LDOPT),)
  LDOPT := $(LDOPT),$(USE_LDOPT)
endif

# Link time optimizations
ifeq ($(USE_LTO),yes)
  OPT += -flto
endif

# FPU-related options
ifeq ($(USE_FPU),)
  USE_FPU = no
endif
ifneq ($(USE_FPU),no)
  OPT += -mfloat-abi=$(USE_FPU) -mfpu=fpv4-sp-d16 -fsingle-precision-constant
  DDEFS += -DCORTEX_USE_FPU=TRUE
  DADEFS += -DCORTEX_USE_FPU=TRUE
else
  DDEFS += -DCORTEX_USE_FPU=FALSE
  DADEFS += -DCORTEX_USE_FPU=FALSE
endif

# Source files groups and paths
ifeq ($(USE_THUMB),yes)
  TCSRC += $(CSRC)
  TCPPSRC += $(CPPSRC)
else
  ACSRC += $(CSRC)
  ACPPSRC += $(CPPSRC)
endif
ASRC	  = $(ACSRC)$(ACPPSRC)
TSRC	  = $(TCSRC)$(TCPPSRC)

# Macros
DEFS      = $(DDEFS) $(UDEFS)
ADEFS 	  = $(DADEFS) $(UADEFS)

# Libs
LIBS      = $(DLIBS) $(ULIBS)

# Various settings
MCFLAGS   = -mcpu=$(MCU) -mfix-cortex-m3-ldrd -mthumb -DTHUMB

ASMFLAGS  += $(MCFLAGS)
CFLAGS    += $(MCFLAGS) $(OPT) $(COPT) $(CWARN) $(DEFS)
CPPFLAGS  += $(MCFLAGS) $(OPT) $(CPPOPT) $(CPPWARN) $(DEFS)
LDFLAGS   += $(MCFLAGS) $(OPT) 
#LDFLAGS   += $(MCFLAGS) $(OPT) -nostartfiles $(LLIBDIR) -Wl,-Map=$(BUILDDIR)/$(PROJECT).map,--cref,--no-warn-mismatch,--library-path=$(RULESPATH),--script=$(LDSCRIPT)$(LDOPT)

# Thumb interwork enabled only if needed because it kills performance.

CFLAGS   += -DTHUMB_PRESENT
CPPFLAGS += -DTHUMB_PRESENT
ASMFLAGS  += -DTHUMB_PRESENT

# Pure THUMB mode, THUMB C code cannot be called by ARM asm code directly.
CFLAGS   += -mno-thumb-interwork -DTHUMB_NO_INTERWORKING
CPPFLAGS += -mno-thumb-interwork -DTHUMB_NO_INTERWORKING
ASMFLAGS  += -mno-thumb-interwork -DTHUMB_NO_INTERWORKING
LDFLAGS  += -mno-thumb-interwork



