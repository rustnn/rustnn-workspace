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

build: ## Build all workspace members and trtx-rs
	cargo build
	@if [ -d "$(TRTX_RS_DIR)" ]; then \
		echo "Building trtx-rs..."; \
		cd $(TRTX_RS_DIR) && cargo build; \
	fi

build-release: ## Build all workspace members and trtx-rs in release mode
	cargo build --release
	@if [ -d "$(TRTX_RS_DIR)" ]; then \
		echo "Building trtx-rs in release mode..."; \
		cd $(TRTX_RS_DIR) && cargo build --release; \
	fi

test: ## Run tests for all workspace members and trtx-rs
	cargo test
	@if [ -d "$(TRTX_RS_DIR)" ]; then \
		echo "Testing trtx-rs..."; \
		cd $(TRTX_RS_DIR) && cargo test; \
	fi

check: ## Run cargo check on all workspace members and trtx-rs
	cargo check --workspace
	@if [ -d "$(TRTX_RS_DIR)" ]; then \
		echo "Checking trtx-rs..."; \
		cd $(TRTX_RS_DIR) && cargo check --workspace; \
	fi

fmt: ## Format all code in the workspace and trtx-rs
	cargo fmt --all
	@if [ -d "$(TRTX_RS_DIR)" ]; then \
		echo "Formatting trtx-rs..."; \
		cd $(TRTX_RS_DIR) && cargo fmt --all; \
	fi

clippy: ## Run clippy on all workspace members and trtx-rs
	cargo clippy --workspace -- -D warnings
	@if [ -d "$(TRTX_RS_DIR)" ]; then \
		echo "Clippy on trtx-rs..."; \
		cd $(TRTX_RS_DIR) && cargo clippy --workspace -- -D warnings; \
	fi

clean: ## Clean build artifacts
	cargo clean
	@if [ -d "$(TRTX_RS_DIR)" ]; then \
		echo "Cleaning trtx-rs..."; \
		cd $(TRTX_RS_DIR) && cargo clean; \
	fi

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
