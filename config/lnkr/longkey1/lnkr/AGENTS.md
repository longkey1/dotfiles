# Repository Guidelines

## Project Structure & Module Organization
- Root entrypoint: `main.go` calls `cmd.Execute()`.
- CLI commands: `cmd/` (Cobra subcommands like `init`, `add`, `link`, etc.).
- Core logic: `internal/lnkr/` (config, link ops, git exclude handling).
- Version info: `internal/version/`.
- Binaries/artifacts: `bin/` and `dist/` (generated).
- Config file managed at runtime: `.lnkr.toml` (not committed by design).

## Build, Test, and Development Commands
- `make build` — Build to `bin/lnkr`.
- `make build-dev` — Build with dev version/commit metadata.
- `make test` — Run `go test ./...`.
- `make lint` — Run `golangci-lint`.
- `go run .` — Run the CLI locally.
- Releases are tag-driven via GoReleaser; see `make release` and `make re-release` (dry-run by default).

## Coding Style & Naming Conventions
- Language: Go (modules). Use `gofmt`/`goimports` formatting; keep idiomatic Go (tabs, line length ~120).
- Packages: lower case, no underscores (e.g., `lnkr`).
- Exported identifiers: CamelCase with leading capital; unexported: camelCase.
- CLI flags/commands: kebab-case (e.g., `--with-create-remote`).
- Keep changes minimal and focused; prefer small, composable functions in `internal/lnkr` with clear inputs/outputs.

## Testing Guidelines
- Framework: Go `testing` package; place tests next to code in `*_test.go`.
- Name tests `TestXxx`; prefer table-driven tests and `t.Run` subtests.
- Run tests locally with `make test`. Add tests for new behavior and edge cases (paths, symlinks, git exclude markers).

## Commit & Pull Request Guidelines
- Follow Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:` (see `git log`).
- Commits should be atomic and scoped to one concern.
- PRs must include: concise description, rationale, usage examples (e.g., `lnkr init --remote /path`), and any related issue IDs.
- Verify `make lint` and `make test` pass; include before/after snippets or CLI output when relevant.

## Security & Configuration Tips
- The tool edits `.git/info/exclude` and creates links; test on a disposable repo before wide use.
- Environment variables: `LNKR_REMOTE_ROOT`, `LNKR_REMOTE_DEPTH` influence defaults.
- Do not commit `.lnkr.toml`; it is auto-excluded.
