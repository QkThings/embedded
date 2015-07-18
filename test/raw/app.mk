
QKPROGRAM_DIR = qkprogram

INCLUDE_DIR += \
$(QKPROGRAM_DIR)/include \
$(QKPROGRAM_DIR)/lib/sys \
$(QKPROGRAM_DIR)/lib/hal/include \
$(QKPROGRAM_DIR)/lib/core/include \
$(QKPROGRAM_DIR)/lib/protocol/include \
$(QKPROGRAM_DIR)/lib/utils/include 

C_SRC_DIR += \
$(QKPROGRAM_DIR)/lib/hal \
$(QKPROGRAM_DIR)/lib/core \
$(QKPROGRAM_DIR)/lib/protocol \
$(QKPROGRAM_DIR)/lib/utils

DEFINES += QK_PROGRAM_RAW