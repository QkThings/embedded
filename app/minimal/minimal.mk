
PROJECT_NAME = minimal
APP_DIR = app/$(PROJECT_NAME)

INCLUDE_DIRS += \
qkperipheral/include \
qkprogram/include \
$(APP_DIR)

C_SRC_DIRS += \
$(APP_DIR)

DEFINES += BUILD_DEVICE QK_PROGRAM_USE_PERIPH

# IMPORTANT: Since qkprogram depends on qkperipheral, qkperipheral MUST be linked
# after the qkprogram is

LIBS += -L"qkprogram/build/$(TARGET_CPU)/$(TARGET_BOARD)/device/lib" -lqkprogram
LIBS += -L"qkperipheral/build/$(TARGET_CPU)/$(TARGET_BOARD)/lib" -lqkperipheral


include qkperipheral/target/$(TARGET_CPU)/board/$(TARGET_BOARD).mk

