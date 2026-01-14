# Repository Guidelines

## Project Structure & Module Organization
- `main.go` boots the CLI.
- `cmd/` holds Cobra command definitions (`auth`, `list`, `get`, `version`, `root`); keep new commands here.
- `internal/gml/` contains core config/service logic; extend it before wiring into commands.
- `internal/google/` handles Gmail API + auth helpers; avoid direct API calls elsewhere.
- `internal/version/` tracks CLI version info.
- `bin/` is the build output target; not checked in.

## Build, Test, and Development Commands
- `make build` – compile to `./bin/gml`.
- `go run . <command>` – run locally (e.g., `go run . list -n 5`).
- `go test ./...` – run unit tests when present.
- `make release type=patch|minor|major dryrun=false` – tag/push release (maintainers only; defaults to dry run).
- `make init` – generate `.devcontainer/devcontainer.json` from the dist template.

## Coding Style & Naming Conventions
- Go 1.23; format with `gofmt` (and `goimports` if available) before sending PRs.
- Prefer clear, small functions; handle errors explicitly and wrap with context where helpful.
- Follow Cobra patterns for flags/help text; keep flag names kebab-case and concise.
- Name config/env keys in lower snake_case to match existing TOML.

## Testing Guidelines
- Add table-driven tests in `*_test.go` beside the code under test; keep package names consistent.
- Stub Gmail interactions—avoid live API calls in tests; prefer fakes that return sample payloads.
- Use `go test -run <pattern> ./...` to scope runs; aim for coverage on parsing, flag handling, and config loading.

## Commit & Pull Request Guidelines
- Commit history follows Conventional Commits (`feat:`, `fix:`, `refactor:`, `chore:`). Continue this pattern.
- PRs should include: what changed, why, user impact (new flags/behavior), manual test notes (`gml list …` output), and any docs/config updates.
- Link relevant issues; include screenshots only when output formatting changes.

## Security & Configuration Tips
- Do not commit credential files; keep `~/.config/gml/config.toml`, OAuth client JSON, and tokens out of the repo.
- If adding new configuration, document it in `README.md` and provide sane defaults/fallbacks.
