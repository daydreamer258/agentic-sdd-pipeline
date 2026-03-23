# Example Feature: Demo Search

This example shows the intended lightweight folder shape for a feature run.

Suggested usage:

```sh
./scripts/init-feature.sh 001 demo-search "Demo Search"
./hooks/before_stage_transition.sh ./features/001-demo-search spec
./hooks/before_stage_transition.sh ./features/001-demo-search plan
./hooks/before_stage_transition.sh ./features/001-demo-search tasks
./hooks/before_implement.sh ./features/001-demo-search
```

The example is intentionally lightweight.
It demonstrates structure and flow rather than a completed product artifact chain.
