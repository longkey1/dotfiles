# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

**gotion** is a CLI tool for interacting with the Notion API. It supports two backends:
- **MCP (Model Context Protocol)**: Uses Dynamic Client Registration (RFC 7591). No pre-setup required.
- **API**: Traditional REST API. Requires Client ID/Secret.

## Development Environment

Go must be invoked via `direnv exec go` (not `go` directly). All Makefile targets handle this automatically, so prefer `make` targets over raw `go` commands.

## Common Commands

```bash
make build          # Build binary to ./bin/gotion (use this, not go build)
make test           # Run all tests
make fmt            # Format code
make vet            # Vet code
make tidy           # Tidy dependencies
make clean          # Remove ./bin/

# Run a single test
direnv exec go test ./internal/gotion/... -run TestFunctionName -v

# Release management
make release type=patch dryrun=true    # Preview patch release
make release type=patch dryrun=false   # Create and push patch release
make re-release dryrun=false           # Recreate release for latest tag
```

## Architecture

```
cmd/                        # CLI commands (Cobra)
    root.go                 # Root command; PersistentPreRunE handles auto token refresh
    auth.go                 # Auth command (MCP and API flows)
    list.go / get.go        # Notion page search and retrieval
    config.go               # Display current config (masks sensitive values)
internal/
    gotion/                 # Application business logic
        config/config.go    # Config management (Viper); token file persistence
        auth.go             # OAuth callback HTTP server (localhost)
        format.go           # Markdown/YAML frontmatter formatting
        page.go             # Page ID extraction utility
    notion/                 # Notion client abstraction
        types/types.go      # Client interface definition
        client.go           # Factory: returns MCP or API client based on config
        api/                # REST API backend (api.notion.com)
        mcp/                # MCP backend (mcp.notion.com) with SSE + PKCE
    version/version.go      # Version info injected via ldflags at build time
```

### Key Design Patterns

**Multi-backend via interface**: `internal/notion/types.Client` is the interface both `api` and `mcp` packages implement. `internal/notion/client.go` acts as a factory returning the appropriate client based on config.

**Automatic token refresh**: `cmd/root.go`'s `PersistentPreRunE` runs before every subcommand. It checks `config.NeedsRefresh()` (5-minute buffer before expiry) and refreshes MCP tokens automatically.

**Config priority**: environment variables → config file (`~/.config/gotion/config.toml`) → token file (`~/.config/gotion/token.json`)

## Configuration

| Environment Variable    | Config Key          | Description                      |
|------------------------|---------------------|----------------------------------|
| `GOTION_BACKEND`       | `backend`           | `"mcp"` (default) or `"api"`     |
| `GOTION_API_TOKEN`     | `api_token`         | Direct access token              |
| `GOTION_API_CLIENT_ID` | `api_client_id`     | OAuth Client ID (API backend)    |
| `GOTION_API_CLIENT_SECRET` | `api_client_secret` | OAuth Client Secret (API backend) |
| `NOTION_TOKEN`         | —                   | Fallback direct token            |

Token data (access token, refresh token, expiry) is stored in `~/.config/gotion/token.json`.

## MCP Backend Implementation Notes

- Uses RFC 8414 for OAuth metadata discovery
- Uses RFC 7591 Dynamic Client Registration (no manual client setup needed)
- Uses PKCE (`code_challenge_method=S256`) for the authorization flow
- Communicates via Server-Sent Events (SSE)
