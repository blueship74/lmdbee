# Thanks to Job Vranish (https://spin.atomicobject.com/2016/08/26/makefile-c-projects/)
# and Chase Lambert (https://makefiletutorial.com/)
TARGET_EXEC ?= lmdbee

BUILD_DIR ?= ./build
SRC_DIRS ?= ./src
LIB_DIR ?= ./lib

# C, C++ and Assembly
SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

# Static libraries
STATIC_LIBS := $(LIB_DIR)/lmdb/libraries/liblmdb/liblmdb.a

# Every folder in ./src will need to be passed to GCC so that it can find header files
# Addes the LMDB includes too
INC_DIRS := $(shell find $(SRC_DIRS) -type d) $(LIB_DIR)/lmdb/libraries/liblmdb
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# The -MMD and -MP flags together generate Makefiles for us!
# These files will have .d instead of .o as the output.
CPPFLAGS ?= $(INC_FLAGS) -MMD -MP

# The final build step.
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS) lmdb
	$(CC) $(OBJS) $(STATIC_LIBS) -o $@ $(LDFLAGS)

# assembly
$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

# LMDB
lmdb: $(LIB_DIR)/lmdb/libraries/liblmdb/Makefile
	cd $(LIB_DIR)/lmdb/libraries/liblmdb && $(MAKE)
$(LIB_DIR)/lmdb/libraries/liblmdb/Makefile:
	$(MKDIR_P) $(LIB_DIR) && cd $(LIB_DIR) && git clone https://github.com/LMDB/lmdb.git && cd lmdb && git checkout LMDB_0.9.29

.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)
	$(RM) -r $(LIB_DIR)

-include $(DEPS)

MKDIR_P ?= mkdir -p
