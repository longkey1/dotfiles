# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`gojira` is a command-line interface tool for JIRA, written in Go. It provides commands to interact with JIRA's REST API v3 for listing issues, fetching issue details, managing fields, and merging JSON files containing issue data.

## Architecture

### Package Structure

```
cmd/                 - Cobra command definitions (package cmd)
  ├── root.go        - Root command definition and Execute function
  ├── list.go        - List command
  ├── get.go         - Get command
  ├── fields.go      - Fields command
  ├── merge.go       - Merge command
  ├── version.go     - Version command
  └── util.go        - Shared utility functions (parseFields, outputJSON)
cmd/gojira/          - Main entry point
  └── main.go        - Application entry point (package main)
internal/
  ├── config/        - Environment variable loading with expansion support
  ├── jira/          - JIRA REST API client and search functionality
  ├── models/        - Data models (Issue, Field)
  └── version/       - Version information (populated via ldflags at build time)
```

### Key Design Patterns

- **CLI Framework**: Uses `spf13/cobra` for command structure. All commands are in `cmd/` package and registered in `cmd/root.go`. The main entry point in `cmd/gojira/main.go` calls `cmd.Execute()`
- **API Client**: `jira.Client` handles HTTP communication with JIRA API v3, including authentication via Basic Auth (email + API token)
- **Configuration**: Environment variables support expansion syntax (`${VAR}` or `$VAR`) for referencing other variables
- **Output**: All commands output JSON to stdout following JIRA API response structure

### Authentication Flow

The client uses Basic Authentication with Base64-encoded email and API token. Required environment variables:
- `JIRA_EMAIL` - JIRA account email
- `JIRA_API_TOKEN` - API token from https://id.atlassian.com/manage-profile/security/api-tokens
- `JIRA_BASE_URL` - JIRA instance URL (e.g., https://your-domain.atlassian.net)

## Development Commands

### Build and Run
```bash
make build          # Build binary to ./bin/gojira
./bin/gojira --help # Run the built binary
make help           # Show all available make targets
```

Note: GoReleaser builds use ldflags to inject version information into `internal/version/` package variables (Version, CommitSHA, BuildTime). Local `make build` produces a "dev" version.

### Testing and Code Quality
```bash
make test           # Run all tests
make fmt            # Format code with go fmt
make vet            # Run go vet
make tidy           # Tidy go.mod dependencies
```

### Release Management
```bash
make release type=patch dryrun=true   # Show what would happen
make release type=patch dryrun=false  # Create and push new patch version tag
make release type=minor dryrun=false  # Increment minor version
make release type=major dryrun=false  # Increment major version

make re-release tag=v1.0.0 dryrun=false  # Recreate a release tag at current HEAD
```

**Requirements**: `re-release` command requires `gh` (GitHub CLI) to be installed and authenticated.

Release process:
1. Tag is created and pushed to GitHub
2. GitHub Actions workflow (`.github/workflows/gorelease.yml`) triggers
3. GoReleaser builds binaries for multiple platforms (Linux, macOS; amd64, arm64)
4. Binaries are attached to GitHub release with version info embedded via ldflags

### Other Commands
```bash
make clean          # Remove ./bin directory
make tools          # Install goreleaser locally
```

## Adding New Commands

To add a new command:
1. Create a new file in `cmd/` (e.g., `newcmd.go`)
2. Define a `cobra.Command` variable with `package cmd`
3. Register it in `cmd/root.go` via `rootCmd.AddCommand(newCmd)` in the `init()` function
4. If JIRA API interaction is needed, add methods to `internal/jira/client.go` or `internal/jira/search.go`

## Working with JIRA API

- API endpoints use `/rest/api/3/` prefix
- Client automatically adds authentication headers and content-type
- Field filtering is supported via query parameters
- JQL (JIRA Query Language) is used for issue searches in the `list` command
- Custom fields are supported through the flexible `Fields` map in the Issue model

## Testing

Currently, there are no test files in the repository. When adding tests:
- Place test files alongside source files with `_test.go` suffix
- Run tests with `make test` or `go test ./...`
