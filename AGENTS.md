# rustnn-workspace - Multi-Project Agent Guide

This workspace contains six interconnected projects for WebNN (Web Neural Network) implementation,
specification tooling, and GPU acceleration.

## Architecture Documentation

**📐 [Complete Architecture Overview](README.md#architecture-overview)** - Comprehensive diagrams and explanations:
- **System Architecture** - How all components fit together
- **Data Flow** - From ONNX/WebNN input through validation to multi-backend execution
- **Internal Architecture** - Deep dive into rustnn's layered design
- **Backend Selection** - W3C-compliant device selection strategy
- **Shared Utilities** - webnn-onnx-utils as single source of truth
- **Development Workflow** - End-to-end example with code

**Start here** to understand the complete system before diving into individual projects.

---

## Project Overview

```
rustnn-workspace/
├── rustnn/              Core WebNN implementation (Rust library)
├── pywebnn/            Python bindings for rustnn (PyO3)
├── trtx-rs/            NVIDIA TensorRT bindings (Rust)
├── webnn-graph/        WebNN graph DSL and ONNX conversion
├── webnn-onnx-utils/   Shared ONNX/WebNN utilities
└── search-bikeshed/    WebNN spec search tool (Python)
```

## Quick Navigation

### rustnn - Core WebNN Implementation
**Purpose**: W3C WebNN specification implementation (Rust library crate)

**Key capabilities**:
- Validates and executes WebNN graphs
- Multi-backend support: TensorRT (NVIDIA GPU), ONNX Runtime (CPU/GPU), CoreML (macOS)
- ONNX and CoreML format converters
- 88/105 WebNN operations implemented (84% spec coverage)
- Rust library API for embedding in applications

**Documentation**:
- **[rustnn/AGENTS.md](rustnn/AGENTS.md)** - Complete architecture and development guide
- **[rustnn/README.md](rustnn/README.md)** - User guide and API reference
- **[rustnn/docs/](rustnn/docs/)** - Detailed documentation

**Key modules**: graph.rs, validator.rs, converters/, executors/

---

### pywebnn - Python Bindings
**Purpose**: Python API for rustnn implementing W3C WebNN specification

**Key capabilities**:
- Full W3C WebNN Python API (ML, MLContext, MLGraphBuilder, MLGraph, MLOperand)
- PyO3-based bindings to rustnn core
- NumPy array integration for inputs/outputs
- ONNX Runtime and CoreML backend support
- 2300+ tests passing (71% pass rate with backends enabled)

**Documentation**:
- **[pywebnn/README.md](https://github.com/rustnn/pywebnn/blob/main/README.md)** - User guide and installation
- **[pywebnn/docs/getting-started.md](https://github.com/rustnn/pywebnn/blob/main/docs/getting-started.md)** - Quick start guide
- **[pywebnn/docs/api-reference.md](https://github.com/rustnn/pywebnn/blob/main/docs/api-reference.md)** - Complete API documentation

**Key modules**: src/python/ (PyO3 bindings), python/webnn/ (Python wrapper)

---

### trtx-rs - TensorRT Bindings
**Purpose**: Safe Rust bindings to NVIDIA TensorRT-RTX for GPU inference

**Key capabilities**:
- Safe RAII-based API over TensorRT C++ API
- Two-phase workflow: build (AOT) and inference (runtime)
- Mock mode for development without GPU
- ONNX parser and CUDA memory management

**Documentation**:
- **[trtx-rs/README.md](trtx-rs/README.md)** - Complete API guide and examples
- **[trtx-rs/docs/DESIGN.md](trtx-rs/docs/DESIGN.md)** - Architecture details

**Crates**: trtx-sys (FFI layer), trtx (safe wrapper)

---

### webnn-graph - Graph DSL and Visualizer
**Purpose**: WebNN graph DSL for authoring, validation, and conversion

**Key capabilities**:
- Parse .webnn text format to JSON AST
- Validate graph structure and weights
- Convert ONNX models to WebNN (with constant folding)
- Emit JavaScript builder code
- Generate interactive HTML visualizer

**Documentation**:
- **[webnn-graph/AGENTS.md](webnn-graph/AGENTS.md)** - Complete development guide
- **[webnn-graph/README.md](webnn-graph/README.md)** - User guide and examples
- **[webnn-graph/docs/](webnn-graph/docs/)** - Additional documentation

**Key modules**: parser.rs, ast.rs, serialize.rs, validate.rs, onnx_convert.rs

---

### webnn-onnx-utils - Shared Utilities
**Purpose**: Common ONNX/WebNN conversion utilities used by rustnn and webnn-graph

**Key capabilities**:
- Data type mapping (WebNN ↔ ONNX)
- Operation name mapping (90+ operations)
- Attribute parsing/building for ONNX NodeProto
- Shape inference for operations
- Tensor data conversion

**Documentation**:
- **[webnn-onnx-utils/README.md](webnn-onnx-utils/README.md)** - API guide and examples

**Key modules**: data_types.rs, operation_names.rs, attributes.rs, shape_inference.rs

---

### search-bikeshed - Spec Search Tool
**Purpose**: Index and search W3C WebNN Bikeshed specification documents

**Key capabilities**:
- Index .bs spec files from URLs
- Full-text search with SQLite FTS5
- Context-aware search (show lines around matches)
- Batch indexing from config file
- Efficient change detection (ETag/hash-based)

**Documentation**:
- **[search-bikeshed/CLAUDE.md](search-bikeshed/CLAUDE.md)** - Complete tool guide
- **[search-bikeshed/README.md](search-bikeshed/README.md)** - User guide

**Usage**: Enables offline searching of WebNN spec without web browsing

---

## Project Relationships

### Dependency Graph
```
pywebnn ──→ rustnn ──┬─→ webnn-onnx-utils ←── webnn-graph
                     │
                     └─→ trtx-rs (optional, for TensorRT backend)

search-bikeshed (independent tool for spec browsing)
```

### Data Flow
```
1. Author: Write .webnn graph (webnn-graph DSL) or use Python API (pywebnn)
2. Convert: ONNX → WebNN (webnn-graph)
3. Python: Build graphs with pywebnn API → rustnn core
4. Validate: WebNN graph validation (rustnn validator)
5. Execute: WebNN graph execution (rustnn executors)
   - Backend options: TensorRT (trtx-rs), ONNX Runtime, CoreML
6. Reference: Search WebNN spec (search-bikeshed)
```

### Shared Code
- **webnn-onnx-utils** provides common utilities:
  - Used by rustnn for ONNX conversion and type mapping
  - Used by webnn-graph for ONNX import and operation mapping
  - Ensures consistent behavior across conversion paths

---

## Cross-Project Development Patterns

### Adding WebNN Operations
When adding a new WebNN operation, you may need to update multiple projects:

1. **webnn-onnx-utils**: Add operation name mapping
   - Update `operation_names.rs` with bidirectional mapping
   - Add shape inference logic if needed
   - Run: `cd webnn-onnx-utils && cargo test`

2. **rustnn**: Implement operation in core library
   - Add shape inference in `shape_inference.rs`
   - Add ONNX converter mapping in `converters/onnx.rs`
   - Add CoreML converter mapping in `converters/coreml_mlprogram.rs`
   - See: [rustnn/AGENTS.md - Adding New WebNN Operations](rustnn/AGENTS.md)
   - Run: `cd rustnn && make test`

3. **pywebnn**: Add Python API binding
   - Add method in `src/python/graph_builder.rs`
   - Add WPT conformance tests in `tests/wpt_data/conformance/`
   - Run: `cd pywebnn && make test`

4. **webnn-graph**: Update parser/serializer if needed
   - Usually no changes needed (generic operation handling)
   - Update if operation has special syntax requirements
   - Run: `cd webnn-graph && cargo test`

### Type System Changes
Changes to data type handling affect all projects:

1. **webnn-onnx-utils**: Add type mapping in `data_types.rs`
2. **rustnn**: Update `graph.rs` DataType enum
3. **webnn-graph**: Update `ast.rs` DataType enum
4. **Test all three**: Ensure consistent behavior

### Backend Integration
Adding a new execution backend to rustnn:

1. Create executor in `rustnn/src/executors/your_backend.rs`
2. Add feature flag in `rustnn/Cargo.toml`
3. May depend on external bindings (like trtx-rs for TensorRT)
4. Update context.rs backend selection logic
5. See: [rustnn/AGENTS.md - Adding New Executor](rustnn/AGENTS.md)

---

## Workspace Commands

All commands work from workspace root:

```bash
# Setup
make setup          # Clone all repos and set up workspace

# Build
make build          # Build all projects
make build-release  # Release build with optimizations

# Test
make test           # Run all tests

# Quality
make fmt            # Format all code
make clippy         # Lint all code
make check          # Quick compile check

# Git
make status         # Git status for all projects
make update         # Pull latest changes
```

---

## Key Technical Decisions

### Backend Selection Strategy (rustnn)
- Follows [W3C WebNN Device Selection Explainer](https://github.com/webmachinelearning/webnn/blob/main/device-selection-explainer.md)
- Backend chosen at context creation (not compile-time)
- Platform autonomously selects device based on hints and availability

### Graph Representation (rustnn)
- Backend-agnostic immutable graph (GraphInfo)
- Lazy conversion during compute() execution
- Same graph can execute on multiple backends

### DSL Design (webnn-graph)
- .webnn text format is primary (10x smaller than JSON)
- Separates graph structure from weights data
- Full round-trip support (.webnn ↔ JSON)

### Shared Utilities (webnn-onnx-utils)
- Single source of truth for ONNX/WebNN mappings
- Prevents divergence between projects
- Minimal, focused API

---

## Testing Strategy

### Per-Project Tests
```bash
# rustnn: Rust + Python + WPT conformance tests
cd rustnn
cargo test --lib
make python-test

# trtx-rs: Rust tests + mock mode + GPU tests
cd trtx-rs
cargo test                          # Without GPU (mock mode)
cargo test --features mock          # Explicit mock mode
# GPU tests run on CI with real hardware

# webnn-graph: Rust tests
cd webnn-graph
cargo test

# webnn-onnx-utils: Rust tests
cd webnn-onnx-utils
cargo test

# search-bikeshed: Python tests
cd search-bikeshed
make test
```

### Workspace-Level Tests
```bash
# Run all tests from workspace root
make test
```

---

## Documentation Index

### Architecture Documents
- **[rustnn/docs/architecture/overview.md](rustnn/docs/architecture/overview.md)** - Core WebNN architecture
- **[rustnn/docs/architecture/chromium-comparison.md](rustnn/docs/architecture/chromium-comparison.md)** - Comparison with Chromium WebNN
- **[trtx-rs/docs/DESIGN.md](trtx-rs/docs/DESIGN.md)** - TensorRT bindings design

### Development Guides
- **[rustnn/docs/development/setup.md](rustnn/docs/development/setup.md)** - rustnn dev environment
- **[rustnn/docs/development/contributing.md](rustnn/docs/development/contributing.md)** - Contributing guide
- **[webnn-graph/docs/dynamic-dimensions-guide.md](webnn-graph/docs/dynamic-dimensions-guide.md)** - ONNX dimension handling

### API References
- **[rustnn/docs/user-guide/api-reference.md](rustnn/docs/user-guide/api-reference.md)** - Complete Python API docs
- **[trtx-rs/README.md](trtx-rs/README.md)** - TensorRT Rust API

### Testing Guides
- **[rustnn/docs/testing/wpt-test-guide.md](rustnn/docs/testing/wpt-test-guide.md)** - W3C conformance testing

---

## External Resources

### W3C WebNN Specification
Use search-bikeshed for efficient spec browsing:

```bash
# Index the WebNN spec (first time)
search-bs index https://github.com/webmachinelearning/webnn/blob/main/index.bs --name webnn

# Search for API details
search-bs search --name webnn "MLTensor" --around 3

# Get specific line ranges
search-bs get --name webnn --line 1234 --count 40
```

### Reference Implementations
- **Chromium WebNN**: https://chromium.googlesource.com/chromium/src/+/lkgr/services/webnn/
  - ONNX Runtime backend: graph_builder_ort.cc
  - CoreML backend: graph_builder_coreml.mm
  - Always check Chromium first when implementing new operations

### Specifications
- [W3C WebNN Spec](https://www.w3.org/TR/webnn/)
- [WebNN Device Selection Explainer](https://github.com/webmachinelearning/webnn/blob/main/device-selection-explainer.md)
- [WebNN MLTensor Explainer](https://github.com/webmachinelearning/webnn/blob/main/mltensor-explainer.md)
- [ONNX Specification](https://github.com/onnx/onnx/blob/main/docs/Operators.md)

---

## Common Cross-Project Tasks

### Updating Operation Support
1. Check Chromium reference implementation first
2. Add to webnn-onnx-utils operation mappings
3. Implement in rustnn (Python API, converters, tests)
4. Update webnn-graph if special syntax needed
5. Run full test suite: `make test`

### Debugging Cross-Project Issues
1. Check webnn-onnx-utils tests for data type/operation mapping issues
2. Use webnn-graph visualizer to inspect graph structure
3. Use rustnn validation to check graph correctness
4. Search WebNN spec with search-bikeshed for clarification

### Performance Optimization
1. Profile with rustnn benchmarks
2. Consider backend-specific optimizations in executors/
3. Use trtx-rs for GPU acceleration opportunities
4. Optimize graph structure with webnn-graph transformations

---

This guide evolves with the workspace. Update it when adding new projects or changing
cross-project patterns.
