# Author:      Noname-29-lnin
# Version:     v0.0.29
-include config.mk
-include runtime.mk

.PHONY: create_folder load view remove_all_folders 

create_folder:
	@echo "[INFO] Creating necessary folders..."
	@mkdir -p $(BIN_DIR) $(BUILD_DIR) $(DATA_DIR) $(DOCS_DIR) $(EXAMPLES_DIR) $(INCLUDE_DIR) $(REPORT_DIR) $(SRC_DIR) $(TEST_DIR)
	@mkdir -p $(DATA_RAW_DIR) $(DATA_PROCESSED_DIR)
	@mkdir -p $(REPORT_OUTPUT_DIR) $(REPORT_BENCHMARK_DIR) $(REPORT_PROFILING_DIR)
	@mkdir -p $(PROFILING_VALGRIND_DIR) $(PROFILING_PERF_DIR)
	@touch $(MAIN_TEST).cpp
	@touch $(SRC_FILE)
	@touch runtime.mk
	@echo "VERSION_TEST=" > runtime.mk
	@echo "TEST_NAME=" >> runtime.mk
	@echo "OPTION_NAME=" >> runtime.mk
	@doxygen -g Doxyfile
	@echo "[PASSED] Folders created successfully."

load:
	@echo "[INFO] Saving configuration..."
	@echo "VERSION_TEST=$(VERSION_TEST)" > runtime.mk
	@echo "TEST_NAME=$(TEST_NAME)" >> runtime.mk
	@echo "OPTION_NAME=$(OPTION_NAME)" >> runtime.mk
	@echo "[PASSED] Saved to runtime.mk"
	@cat runtime.mk

view:
	@echo "[INFO] Opening runtime.mk..."
	@cat runtime.mk

remove_all_folders:
	@echo "[INFO] Removing all folders and files..."
	@rm -rf $(BIN_DIR) $(BUILD_DIR) $(DATA_DIR) $(DOCS_DIR) $(EXAMPLES_DIR) $(INCLUDE_DIR) $(REPORT_DIR) $(SRC_DIR) $(TEST_DIR)
	@rm -f runtime.mk
	@rm -f Doxyfile
	@echo "[PASSED] All folders and files removed successfully."

# ===========================
# Source File Handling
# ===========================
ifeq ($(wildcard $(SRC_FILE)),)
    SRC_LIST := $(MAIN_TEST).cpp
else
    SRC_LIST := $(shell cat $(SRC_FILE)) $(MAIN_TEST).cpp
endif
OBJ_LIST := $(addprefix $(BUILD_DIR)/, $(SRC_LIST:.cpp=.o))

.PHONY: all run clean help

all: run

$(MAIN_TEST): $(OBJ_LIST)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $^ -o $@

$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

run: $(MAIN_TEST)
	@mkdir -p $(REPORT_OUTPUT_DIR)
	./$(MAIN_TEST) $(OPTION_NAME) | tee $(REPORT_OUTPUT_DIR)/$(RUN_LOG_NAME)

clean:
	rm -rf $(BUILD_DIR) $(MAIN_TEST)
	rm -rf $(REPORT_OUTPUT_DIR)/$(RUN_LOG_NAME)
	@mkdir -p $(BUILD_DIR) 


help:
	@echo "Makefile Help:"
	@echo "  make create_folder      - Create necessary folders and files"
	@echo "  make load               - Save VERSION_TEST/TEST_NAME/OPTION_NAME to runtime.mk"
	@echo "  make view               - View the contents of runtime.mk"
	@echo "  make all                - Build and run the main test"
	@echo "  make run                - Run the main test"
	@echo "  make clean              - Clean build artifacts and logs"
	@echo "  make remove_all_folders - Remove all folders and files"
	@echo "  make VALGRIND_TEST      - Run the binary under Valgrind"
	@echo "  make PERF_TEST          - Run the binary under perf stat"
	@echo "  make DOXYGEN_TEST       - Generate Doxygen documentation"

.PHONY: VALGRIND_TEST PERF_TEST DOXYGEN_TEST
VALGRIND_TEST: $(MAIN_TEST)
	@echo "[INFO] Running Valgrind test..."
	@mkdir -p $(PROFILING_VALGRIND_DIR)
	@$(TOOL_VALGRIND) --leak-check=full --show-leaks=yes --track-origins=yes ./$(MAIN_TEST) $(OPTION_NAME) | tee $(VALGRIND_LOG)
	@echo "[PASSED] Valgrind test completed. Log saved to $(VALGRIND_LOG)"

PERF_TEST: $(MAIN_TEST)
	@echo "[INFO] Running Perf test..."
	@mkdir -p $(PROFILING_PERF_DIR)
	@$(TOOL_PERF) stat -e cycles,instructions,cache-references,cache-misses ./$(MAIN_TEST) $(OPTION_NAME) | tee $(PERF_LOG)
	@echo "[PASSED] Perf test completed. Log saved to $(PERF_LOG)"

DOXYGEN_TEST:
	@echo "[INFO] Generating Doxygen documentation..."
	@doxygen Doxyfile
	@echo "[PASSED] Doxygen documentation generated in $(DOCS_DIR)/html"