.PHONY: setup clone build test clean fmt check help

# Repository URLs
RUSTNN_REPO := https://github.com/rustnn/rustnn
TRTX_RS_REPO := https://github.com/rustnn/trtx-rs
WEBNN_GRAPH_REPO := https://github.com/rustnn/webnn-graph
WEBNN_ONNX_UTILS_REPO := https://github.com/rustnn/webnn-onnx-utils
SEARCH_BIKESHED_REPO := https://github.com/rustnn/search-bikeshed

# Workspace directories
RUSTNN_DIR := rustnn
TRTX_RS_DIR := trtx-rs
WEBNN_GRAPH_DIR := webnn-graph
WEBNN_ONNX_UTILS_DIR := webnn-onnx-utils
SEARCH_BIKESHED_DIR := search-bikeshed

help: ## Show this help message
	@echo "rustnn-workspace Makefile"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

setup: clone ## Full setup: clone repositories and build workspace
	@echo "✓ Setup complete!"

clone: ## Clone all rustnn project repositories
	@echo "Cloning rustnn project repositories..."
	@if [ ! -d "$(RUSTNN_DIR)" ]; then \
		git clone $(RUSTNN_REPO) $(RUSTNN_DIR); \
	else \
		echo "$(RUSTNN_DIR) already exists, skipping..."; \
	fi
	@if [ ! -d "$(TRTX_RS_DIR)" ]; then \
		git clone $(TRTX_RS_REPO) $(TRTX_RS_DIR); \
	else \
		echo "$(TRTX_RS_DIR) already exists, skipping..."; \
	fi
	@if [ ! -d "$(WEBNN_GRAPH_DIR)" ]; then \
		git clone $(WEBNN_GRAPH_REPO) $(WEBNN_GRAPH_DIR); \
	else \
		echo "$(WEBNN_GRAPH_DIR) already exists, skipping..."; \
	fi
	@if [ ! -d "$(WEBNN_ONNX_UTILS_DIR)" ]; then \
		git clone $(WEBNN_ONNX_UTILS_REPO) $(WEBNN_ONNX_UTILS_DIR); \
	else \
		echo "$(WEBNN_ONNX_UTILS_DIR) already exists, skipping..."; \
	fi
	@if [ ! -d "$(SEARCH_BIKESHED_DIR)" ]; then \
		git clone $(SEARCH_BIKESHED_REPO) $(SEARCH_BIKESHED_DIR); \
	else \
		echo "$(SEARCH_BIKESHED_DIR) already exists, skipping..."; \
	fi
	@echo "✓ All repositories cloned"

build: ## Build all workspace members
	cargo build

build-release: ## Build all workspace members in release mode
	cargo build --release

test: ## Run tests for all workspace members
	cargo test

check: ## Run cargo check on all workspace members
	cargo check --workspace

fmt: ## Format all code in the workspace
	cargo fmt --all

clippy: ## Run clippy on all workspace members
	cargo clippy --workspace -- -D warnings

clean: ## Clean build artifacts
	cargo clean

update: ## Update all subproject repositories
	@echo "Updating repositories..."
	@for dir in $(RUSTNN_DIR) $(TRTX_RS_DIR) $(WEBNN_GRAPH_DIR) $(WEBNN_ONNX_UTILS_DIR) $(SEARCH_BIKESHED_DIR); do \
		if [ -d "$$dir" ]; then \
			echo "Updating $$dir..."; \
			cd $$dir && git pull && cd ..; \
		fi \
	done
	@echo "✓ All repositories updated"

status: ## Show git status for all subprojects
	@echo "=== Workspace Status ==="
	@for dir in $(RUSTNN_DIR) $(TRTX_RS_DIR) $(WEBNN_GRAPH_DIR) $(WEBNN_ONNX_UTILS_DIR) $(SEARCH_BIKESHED_DIR); do \
		if [ -d "$$dir" ]; then \
			echo ""; \
			echo "--- $$dir ---"; \
			cd $$dir && git status -s && cd ..; \
		fi \
	done
