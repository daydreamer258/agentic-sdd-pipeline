# Example Runtime Demo

This example shows the intended lightweight runtime flow.

```sh
./scripts/init-feature.sh 002 runtime-demo "Runtime Demo"
./scripts/run-stage.sh ./features/002-runtime-demo intake
# run intake skill manually and update 00-intake.md
./scripts/complete-artifact.sh ./features/002-runtime-demo 00-intake.md

./scripts/run-stage.sh ./features/002-runtime-demo spec
# run spec skill / subagent manually and update 01-spec.md
./scripts/complete-artifact.sh ./features/002-runtime-demo 01-spec.md

./scripts/run-stage.sh ./features/002-runtime-demo plan
./scripts/complete-artifact.sh ./features/002-runtime-demo 02-plan.md

./scripts/run-stage.sh ./features/002-runtime-demo tasks
./scripts/complete-artifact.sh ./features/002-runtime-demo 06-tasks.md

./scripts/run-stage.sh ./features/002-runtime-demo implement
# perform implementation and write 07-implementation-log.md
./scripts/complete-artifact.sh ./features/002-runtime-demo 07-implementation-log.md

./scripts/run-stage.sh ./features/002-runtime-demo validate
# validator writes 08-validation.md
./scripts/complete-artifact.sh ./features/002-runtime-demo 08-validation.md
```

The key point is that `run-stage.sh` prepares the next stage and `complete-artifact.sh` records artifact completion.
