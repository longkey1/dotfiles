# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

**ビルド確認には `make build` を使用すること。`go build` は使わない。**

```bash
# Build binary to dist/
make build

# Run directly
go run .

# Run tests
go test ./...

# Install tools (goreleaser)
make tools

# Tidy dependencies
go mod tidy
```

## Release

```bash
# Show current version and usage
make release

# Create a new release (dry run by default)
make release type=patch   # v1.2.3 -> v1.2.4
make release type=minor   # v1.2.3 -> v1.3.0
make release type=major   # v1.2.3 -> v2.0.0

# Actually create and push tag
make release type=patch dryrun=false
```

GitHub Actions automatically builds release binaries when a tag is pushed.

## Architecture

jnal is a text file-based journal CLI tool written in Go. It manages daily journal files with configurable templates and external editor integration.

### Package Structure

- `main.go` - Entry point; sets version info and calls `cmd.Execute()`
- `cmd/` - CLI commands using Cobra
  - `root.go` - Root command, config loading via PersistentPreRunE
  - `new.go` - Creates journal entry for a date
  - `path.go` - Outputs file/directory paths
  - `serve.go` - Local preview server with hot reload
  - `init.go` - Initializes configuration file
  - `version.go` - Shows version information
- `internal/config/` - Configuration management
  - `config.go` - Config struct, validation, defaults
  - `loader.go` - Viper-based config loading
- `internal/journal/` - Core journal operations
  - `journal.go` - Entry creation, file operations
  - `entry.go` - Entry struct, sorting
  - `template.go` - Template execution helpers
- `internal/dateutil/` - Date parsing utilities
- `internal/server/` - HTTP server for preview
  - `server.go` - Server with fsnotify file watching
  - `templates/` - Embedded HTML templates

### Key Design Patterns

- Error handling uses `error` return values (no `log.Fatalf` or `panic`)
- Config is loaded via `PersistentPreRunE` and accessed through `GetConfig()` / `GetJournal()`
- File paths use `filepath.Join()` for cross-platform compatibility
- Templates use Go's `text/template` with `{{ .Date }}`, `{{ .Env.<NAME> }}` placeholders
- Server uses `embed` for HTML templates and `fsnotify` for file watching

### Path Format

Journal file paths are configured via `path_format` using Go's time format:
- `2006-01-02.md` → `2024-01-15.md`
- `2006/2006-01-02.md` → `2024/2024-01-15.md`
- `2006/01/2006-01-02.md` → `2024/01/2024-01-15.md`

## Testing

Run tests with:
```bash
go test ./...
```

Test files are in `internal/dateutil/` and `internal/config/` packages.
