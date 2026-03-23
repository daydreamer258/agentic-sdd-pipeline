# Spec

## Problem Statement
Users of this repository can initialize and advance feature folders, but currently have no lightweight built-in command to inspect the current workflow status of a feature in one place.

## Users / Actors
- repository maintainer
- anyone piloting a feature through the lightweight SDD workflow

## Desired Behavior
Provide a simple CLI script that accepts a feature directory path and prints a short readable summary of the feature's workflow status.

## Acceptance Criteria
- [ ] User can run a script with a feature directory path.
- [ ] Script prints the current stage from `state.json` when available.
- [ ] Script prints the status from `state.json` when available.
- [ ] Script prints the last artifact from `state.json` when available.
- [ ] Script reports whether core artifacts exist: `00-intake.md`, `01-spec.md`, `02-plan.md`, `06-tasks.md`, `07-implementation-log.md`, `08-validation.md`.
- [ ] Script fails with a clear message if the feature directory does not exist.

## Edge Cases
- Feature directory exists but `state.json` is missing.
- Some core artifacts are missing.
- User passes a relative path instead of an absolute one.

## Non-Goals
- Editing artifacts.
- Validating artifact content quality.
- Parsing markdown content deeply.
- Supporting JSON output in v1.

## Assumptions
- A lightweight text summary is sufficient for the first pilot.
- Shell scripting is acceptable and consistent with the repo's current scripts/hooks.
