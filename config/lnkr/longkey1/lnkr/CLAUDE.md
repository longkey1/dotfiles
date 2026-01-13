# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

**重要: ビルドには必ず`make build`を使用すること（`go build`は使わない）**

```bash
make build          # Build to bin/lnkr
make build-dev      # Build with version/commit metadata
make test           # Run all tests (go test -v ./...)
make lint           # Run golangci-lint
make fmt            # Format code with gofmt
make fmt-check      # Check formatting without applying
go run .            # Run CLI locally
```

Run a single test:
```bash
go test -v ./internal/lnkr -run TestFunctionName
```

## Architecture Overview

lnkr is a CLI tool for managing hard links and symbolic links via a `.lnkr.toml` configuration file.

### Code Structure

- `main.go` - Entry point, calls `cmd.Execute()`
- `cmd/` - Cobra CLI commands (init, add, link, unlink, status, remove, clean)
- `internal/lnkr/` - Core logic:
  - `config.go` - Config loading/saving, constants (`ConfigFileName`, `LinkTypeHard`, etc.)
  - `link.go` - Link creation logic with `CreateLinksAuto()` as main entry point
  - `add.go` - Adding files/directories to config
  - `unlink.go` - Removing links
  - `status.go` - Status reporting
  - `init.go` - Project initialization
  - `clean.go` - Cleanup operations
- `internal/version/` - Version information for build

### Key Concepts

- **Config file** (`.lnkr.toml`): Stores local/remote paths, source direction, and link entries
- **Link direction**: Controlled by `source` field in config ("local" or "remote")
  - `source = "local"`: Creates links from local -> remote
  - `source = "remote"`: Creates links from remote -> local
- **Git exclude integration**: Automatically manages `.git/info/exclude` with LNKR section markers (`### LNKR STA` / `### LNKR END`)
- **Link types**: Hard links (default, files only) and symbolic links (files and directories)

### Environment Variables

- `LNKR_REMOTE_ROOT` - Base directory for remote paths
- `LNKR_REMOTE_DEPTH` - Directory depth for default remote path (default: 2)

## Release Process

Releases are tag-driven via GoReleaser:
```bash
make release type=patch|minor|major dryrun=false
```
