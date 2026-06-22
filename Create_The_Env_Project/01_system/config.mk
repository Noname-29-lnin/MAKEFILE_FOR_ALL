# ===========================
# Global Configuration
# ===========================
MAIN_TEST       			= main
SRC_FILE        			= flist.f

BIN_DIR		 				= bin
BUILD_DIR       			= build
DOCS_DIR       			    = docs
EXAMPLES_DIR   			    = examples
INCLUDE_DIR     			= include
SRC_DIR        			    = src
TEST_DIR       			    = tests

DATA_DIR					= data
DATA_RAW_DIR				= $(DATA_DIR)/raw
DATA_PROCESSED_DIR			= $(DATA_DIR)/processed

REPORT_DIR      			= reports
REPORT_OUTPUT_DIR			= $(REPORT_DIR)/output
REPORT_BENCHMARK_DIR		= $(REPORT_DIR)/benchmark
REPORT_PROFILING_DIR		= $(REPORT_DIR)/profiling
PROFILING_VALGRIND_DIR		= $(REPORT_PROFILING_DIR)/valgrind
PROFILING_PERF_DIR			= $(REPORT_PROFILING_DIR)/perf

# ===========================
# Name log Configuration
# ===========================

RUN_LOG_SUFFIX :=

ifneq ($(strip $(VERSION_TEST)),)
    RUN_LOG_SUFFIX := $(RUN_LOG_SUFFIX)_$(VERSION_TEST)
endif

ifneq ($(strip $(TEST_NAME)),)
    RUN_LOG_SUFFIX := $(RUN_LOG_SUFFIX)_$(TEST_NAME)
endif

RUN_LOG_NAME := run$(RUN_LOG_SUFFIX).log
VALGRIND_LOG = $(PROFILING_VALGRIND_DIR)/valgrind$(RUN_LOG_SUFFIX).log
PERF_LOG     = $(PROFILING_PERF_DIR)/perf$(RUN_LOG_SUFFIX).log

# ===========================
# Tools
# ===========================
CXX            := g++
CXXFLAGS       := -Wall -O2 -std=c++17
# TESTFLAGS      := -Wall -O3 -std=c++17 -march=native -DNDEBUG
LDFLAGS        := -pthread
TOOL_VALGRIND 	= valgrind
TOOL_PERF     	= perf