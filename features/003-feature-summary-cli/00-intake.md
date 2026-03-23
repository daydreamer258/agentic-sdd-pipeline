# Intake

## Request Summary
Create a real pilot feature inside this repository: a lightweight CLI script that summarizes the status of a feature folder in the SDD pipeline.

## Why It Matters
The repository already creates feature folders, templates, hooks, and state files, but there is no small runtime utility that lets a human quickly inspect a feature's current workflow state. Building one is a realistic but bounded feature for the first pilot.

## Constraints
- Must fit the current lightweight v1 philosophy.
- Should be implemented as a simple shell script to match the repo's current tooling style.
- Must work on existing feature folders created by `init-feature.sh`.
- Should not introduce heavy dependencies like jq.

## Unknowns / Questions
- Exact output format can remain lightweight as long as it is readable.
- Missing optional artifacts should likely be informational, not errors.

## Initial Success Definition
A user can run a script against a feature folder and get a readable summary showing:
- feature path
- current stage
- status
- last artifact
- presence/absence of core artifacts
