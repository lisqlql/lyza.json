## ---------------------------------------------
## lyza.Makefile

# Sources
SRCS=$(wildcard src/*.cpp)

# Dependencies and object files
OBJS=$(addprefix ${BUILD_DIR}/,$(patsubst %.cpp,%.o,$(SRCS)))
DEPS=$(addprefix ${BUILD_DIR}/,$(patsubst %.cpp,%.d,$(SRCS)))

# Compiler setup
CXX=clang++
CXX_FLAGS=-std=c++0x

# Linker setup
LDD_FLAGS=

# The name of the directory for object files 
BUILD_DIR=.build

# The name of your program
# If you want to use the name of your git project use:
#   $(shell basename `git rev-parse --show-toplevel`)
BIN_NAME=$(shell basename `git rev-parse --show-toplevel`)

# Top level rule
$(BIN_NAME): .depend $(OBJS)
	$(CXX) $(LDD_FLAGS) $(OBJS) -o $(BIN_NAME)

$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p `dirname $@`
	$(CXX) $(CXX_FLAGS) -c -o $@ $<

$(BUILD_DIR)/%.d: %.cpp
	@mkdir -p `dirname $@`
	$(CXX) -MM $< | sed 's#.*\.o:#$(patsubst %.d,%.o,$@):#g' > $@

.depend: $(DEPS)
	cat $(DEPS) > .depend

# Do not include .depend file if command is `clean`
ifneq ($(MAKECMDGOALS),clean)
include .depend
endif

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(BIN_NAME) .depend

.PHONY: clean
