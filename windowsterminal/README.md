# Windows Terminal Settings

- cdsettings.ps1: Change to the Windows Terminal settings directory.

- editsettings.ps1: Directly edit settings.json in the settings directory.

## The problem

Most tools in this repo are configured by symlinking (or stowing) a file
straight out of this repo into the location the tool reads from, so the repo
is always the source of truth. Windows Terminal doesn't cooperate with that:
it treats `settings.json` as a file it owns and rewrites in place — adding
profiles for newly detected shells, WSL distros, Visual Studio dev prompts,
etc. — any time it starts up or a profile changes. A symlink pointed at a
tracked file in this repo would just mean Terminal's auto-generated churn
gets written straight into version control, with no way to tell "settings I
chose" apart from "settings Terminal invented for this machine."

## The solution

Instead of owning `settings.json` outright, this directory tracks the
*intended* customizations separately and merges them on top of whatever
Terminal has generated, via two scripts:

- `DeploySettings.ps1` (run from this repo directory): copies
  `settings.tracked.json`, `changes.json`, and `MergeSettings.ps1` into the
  Terminal LocalState directory, then backs up and deletes the live
  `settings.json`. Terminal watches that file and regenerates a fresh one
  (with its auto-detected profiles) as soon as it notices it's gone — no
  restart needed, just wait for the regenerated file to appear.

- `MergeSettings.ps1` (run from the LocalState directory once Terminal has
  regenerated `settings.json`): layers `settings.tracked.json` (the
  hand-authored theme, schemes, keybindings, and profile defaults) and
  `changes.json` (per-profile directives — hide/unhide, mark as default,
  resolve an executable path, upsert a fully managed profile by name, etc.)
  onto the regenerated file, so machine-specific, auto-detected profiles
  survive while this repo's choices still win. It always backs up
  `settings.json` before writing and supports `-WhatIf`. See the comment
  header in that script for the exact merge rules.

When changing Windows Terminal behavior, edit `settings.tracked.json` or
`changes.json` — never the live `settings.json` on disk — and re-run
`DeploySettings.ps1` / `MergeSettings.ps1` to apply the change.
