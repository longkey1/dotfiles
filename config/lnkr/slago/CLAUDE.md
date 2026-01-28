# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

`slago` is a CLI tool for collecting Slack messages. It uses the Slack API to search, fetch, and organize messages by threads and date ranges.

## Build and Test Commands

```bash
# Build the application
make build                    # Outputs to ./bin/slago

# Run tests
make test                     # Run all tests
go test ./internal/slack/...  # Run specific package tests

# Clean build artifacts
make clean
```

## Release Process

This project uses GoReleaser with GitHub Actions for automated releases.

```bash
# Create a new release (dry run by default)
make release type=patch       # Show what would be done
make release type=minor dryrun=false  # Actually create and push tag
make release type=major dryrun=false

# Re-release an existing tag (useful for fixing release artifacts)
make re-release               # Re-release the latest tag (dry run)
make re-release tag=v1.2.3 dryrun=false  # Re-release specific tag

# Install release tools
make tools                    # Install goreleaser
```

When a tag is pushed, GitHub Actions automatically builds binaries for multiple platforms (linux/darwin, amd64/arm64/arm) using GoReleaser.

## Architecture

### Command Structure

The CLI is built using Cobra with the following command hierarchy:

- **root** (`internal/cli/root.go`) - Base command with global flags
  - **get** - Fetch single message or thread from Slack URL
  - **list** - Collect messages for date ranges
  - **merge** - Merge and deduplicate JSON files
  - **version** - Display version information

### Core Components

**slack/** - Slack API interaction layer
- `client.go` - Wraps slack-go/slack client
- `search.go` - Message search with date/author/mention filtering
- `thread.go` - Thread fetching and expansion
- `url.go` - Parse Slack URLs to extract channel/message IDs
- `channel.go` - Channel information retrieval

**collector/** - Business logic for data collection
- `list.go` - Collects messages for a specific day, handles thread expansion, groups by thread
- `get.go` - Fetches single message or thread from URL
- `merge.go` - Merges multiple JSON files and deduplicates

**model/** - Data structures
- `message.go` - Defines `Message`, `Thread`, and `SearchResult` types
- Messages are transformed from Slack API format into a simplified structure

**output/** - Data output handling
- `file.go` - Writes to filesystem (logs/YYYY/MM/DD/slack.json)
- `stdout.go` - Writes to stdout
- `writer.go` - Writer interface

**dateutil/** - Date range calculation utilities

**config/** - Configuration and environment variable handling

**input/** - Interactive input handling (for prompts)

### Key Design Patterns

**Message Transformation**: The raw Slack API response is transformed into a simplified format. The `Message` type extracts:
- `id` from timestamp (`ts`)
- `mentions` from `<@USER|name>` patterns in text
- `attached_links` from text and attachments
- `is_thread_parent` calculated from `thread_ts`

**Thread Grouping**: Messages are grouped by `thread_ts` (or message ID if not in a thread). When `--thread` is used, the collector fetches all replies for each thread and deduplicates.

**Parallel Execution**: The `list` command supports parallel date range processing using `--parallel` flag. Each day is processed independently.

## Environment Variables

```bash
SLACK_API_TOKEN   # Required: Slack API token
SLACK_AUTHOR      # Optional: Default author filter
SLACK_MENTION     # Optional: Default mention filter (comma-separated)
```

## Testing

Unit tests exist for:
- `internal/dateutil/` - Date range calculation
- `internal/slack/` - URL parsing

To run a single test:
```bash
go test ./internal/slack -run TestParseSlackURL
```

## Output Format

The tool outputs JSON with threads containing messages. The structure is NOT the raw Slack API response but a transformed format optimized for log collection and storage.
