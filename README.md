# rustnn Workspace

This is a Cargo workspace containing all rustnn projects.

## Quick Start

```bash
# Clone all repositories and set up the workspace
make setup

# Build all projects
make build

# Run tests
make test
```

## Workspace Structure

This workspace includes the following projects:

- **rustnn** - Core neural network library
- **trtx-rs** - TensorRT integration for Rust
- **webnn-graph** - WebNN graph implementation
- **webnn-onnx-utils** - ONNX utilities for WebNN
- **search-bikeshed** - Search functionality

## Available Commands

Run `make help` to see all available commands:

- `make setup` - Clone all repositories and set up the workspace
- `make clone` - Clone all project repositories
- `make build` - Build all workspace members
- `make build-release` - Build in release mode with optimizations
- `make test` - Run all tests
- `make check` - Run cargo check
- `make fmt` - Format all code
- `make clippy` - Run clippy linter
- `make clean` - Clean build artifacts
- `make update` - Pull latest changes from all repositories
- `make status` - Show git status for all projects

## Development Workflow

1. **Initial setup**: `make setup`
2. **Make changes** in any of the sub-projects
3. **Build**: `make build`
4. **Test**: `make test`
5. **Format**: `make fmt`
6. **Check**: `make clippy`

## Working with Individual Projects

Each project is a git repository. You can work on them independently:

```bash
cd rustnn
git checkout -b my-feature
# make changes
git commit -m "Add feature"
git push origin my-feature
```

## Workspace Benefits

- **Unified dependency management**: Shared dependencies across projects
- **Cross-project refactoring**: Changes can span multiple crates
- **Single build command**: Build all projects together
- **Consistent tooling**: Shared formatting and linting rules
