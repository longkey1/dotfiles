# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LLMC is a command-line tool for interacting with various LLM APIs (OpenAI and Google Gemini). Built with Go and Cobra CLI framework.

**Supported Platforms:** Linux and macOS

## Build and Development Commands

**CRITICAL: Always use `make` commands for building and testing. NEVER use `go build` or `go test` directly.**

### Building and Installing

```bash
# Build the project (outputs to ./bin/llmc)
make build

# Install to $GOPATH/bin or $HOME/go/bin
go install

# Clean build artifacts
make clean

# Show all available make targets
make help

# Run without installing
go run main.go [command]
```

### Testing

**IMPORTANT: Use `make test` instead of `go test` directly.**

```bash
# Run all tests
make test

# Format code
make fmt

# Vet code
make vet

# Tidy dependencies
make tidy
```

### Release Management

```bash
# Create a new release (dry run)
make release type=patch    # v1.2.3 -> v1.2.4
make release type=minor    # v1.2.3 -> v1.3.0
make release type=major    # v1.2.3 -> v2.0.0

# Execute release (pushes tag to trigger GitHub Actions)
make release type=patch dryrun=false

# Re-release existing tag (useful for fixing releases)
make re-release tag=v1.2.3 dryrun=false
```

GitHub Actions automatically builds and publishes binaries via GoReleaser when tags are pushed.

### Running the Tool

```bash
# Initialize configuration
go run main.go init

# View configuration
go run main.go config

# Chat with LLM
go run main.go chat "Your message here"

# List prompts (shows table with MODEL, WEB SEARCH, and FILE PATH columns)
go run main.go prompts
# The prompts list displays:
# - PROMPT: prompt name
# - MODEL: model specified in prompt (or default in parentheses)
# - WEB SEARCH: enabled/disabled (or default in parentheses)
# - FILE PATH: full path to prompt file
# Values in parentheses indicate defaults from configuration

# Use verbose mode
go run main.go -v chat "Your message"
```

## Architecture

### Command Structure

The CLI uses Cobra framework with commands in `cmd/` directory:
- `root.go` - Base command setup, config initialization via Viper
- `chat.go` - Main chat command, handles message input (args, stdin, or editor)
- `prompt.go` - Lists available prompt templates
- `config.go` - Configuration management
- `init.go` - Initializes config file
- `version.go` - Version information

### Provider Architecture

The tool implements a provider pattern for LLM services:

- `internal/llmc/llmc.go` - Core types and provider interface
  - `Provider` interface defines `Chat(message string) (string, error)` and `ListModels() ([]ModelInfo, error)`
  - `Config` struct holds model (in "provider:model" format), provider-specific base URLs and tokens, prompt directories, web search settings
  - `ParseModelString()` utility function parses "provider:model" format
  - `GetToken(provider)` method resolves token for specified provider (supports environment variable references with `$VAR` or `${VAR}` syntax)
  - `GetBaseURL(provider)` method resolves base URL for specified provider (also supports environment variable references)
  - `NewProvider()` factory creates appropriate provider implementation based on model string

- `internal/openai/openai.go` - OpenAI API implementation
- `internal/gemini/gemini.go` - Google Gemini API implementation

Each provider implements the `Provider` interface and handles API-specific request/response formatting.

### Configuration System

Uses Viper for multi-source configuration with the following precedence (higher priority overrides lower):

1. CLI flags (highest priority)
2. Environment variables: `LLMC_MODEL` (format: "provider:model"), `LLMC_OPENAI_BASE_URL`, `LLMC_OPENAI_TOKEN`, `LLMC_GEMINI_BASE_URL`, `LLMC_GEMINI_TOKEN`, `LLMC_PROMPT_DIRS`, `LLMC_ENABLE_WEB_SEARCH`, `LLMC_IGNORE_WEB_SEARCH_ERRORS`
3. User config file: `$HOME/.config/llmc/config.toml`
4. System-wide config files (searched in order):
   - `/etc/llmc/config.toml` (for package manager installations)
   - `/usr/local/etc/llmc/config.toml` (for `go install` or manual builds)
5. Default values (lowest priority)

Prompt directories support:
- Multiple directories configured in `prompt_dirs` array
- Default directories (later takes precedence):
  1. `/usr/share/llmc/prompts` - System package prompts
  2. `/usr/local/share/llmc/prompts` - Local install prompts
  3. `$HOME/.config/llmc/prompts` - User-specific prompts
- Relative paths resolved relative to config file location
- Later directories take precedence for duplicate prompt names
- All paths converted to absolute paths during config loading

### Prompt Template System

Prompt templates are TOML files with structure:
```toml
system = "System prompt with {{input}} and {{custom}} placeholders"
user = "User prompt with {{input}} and {{custom}} placeholders"
model = "openai:gpt-4"  # Optional model override (format: "provider:model")
web_search = true  # Optional web search override (true/false)
```

- Templates stored in configured prompt directories
- `{{input}}` placeholder replaced with user's message
- Additional placeholders passed via `--arg key:value` flags
- Model field in template overrides default/configured model (must be in "provider:model" format)
- Web search field in template overrides default/configured web search setting
- Template discovery supports subdirectories in prompt directories

## Key Implementation Details

### Message Flow

1. User input collected from CLI args, stdin, or editor (`EDITOR` env var)
2. If prompt specified, template loaded and placeholders replaced
3. Model and web search settings potentially overridden by prompt template fields
4. Config merged from CLI flags, env vars, prompt template, and config files (in that priority order)
5. Provider selected by parsing model string with `ParseModelString()` to extract provider
6. Token and base URL retrieved for selected provider using `GetToken(provider)` and `GetBaseURL(provider)` (both resolve environment variables if needed)
7. Message sent to provider's Chat() method with web search configuration
8. Response (including citations if web search enabled) printed to stdout

### Path Resolution

Prompt directory paths in config can be relative or absolute:
- Relative paths resolved relative to config file directory
- If no config file, resolved relative to current working directory
- All paths converted to absolute during `LoadConfig()`

## Adding New Providers

To add support for a new LLM provider:

1. Create new package in `internal/` (e.g., `internal/claude/`)
2. Define provider name constant and default base URL
3. Implement the `llmc.Provider` interface with `Chat(message, webSearch)` and `ListModels()` methods
4. Update `Config` struct in `internal/llmc/llmc.go`:
   - Add base URL field (e.g., `ClaudeBaseURL`)
   - Add token field (e.g., `ClaudeToken`)
5. Update `Config.GetToken()` and `Config.GetBaseURL()` methods to support the new provider
6. Add case in `cmd/provider.go` `newProvider()` switch statement to handle the new provider
7. Update `cmd/root.go` `initConfig()` to:
   - Set default base URL value (e.g., `"https://api.anthropic.com/v1"`)
   - Set default token value with environment variable reference (e.g., `$CLAUDE_API_KEY`)
   - Bind environment variables (e.g., `viper.BindEnv("claude_base_url", "LLMC_CLAUDE_BASE_URL")` and `viper.BindEnv("claude_token", "LLMC_CLAUDE_TOKEN")`)
8. Update `cmd/models.go` to validate and support the new provider
9. Update `cmd/config.go` to display the new base URL and token fields
