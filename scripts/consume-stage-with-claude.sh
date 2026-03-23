#!/usr/bin/env sh
set -eu

if [ $# -lt 2 ]; then
  echo "usage: $0 <feature-dir> <stage>" >&2
  exit 1
fi

FEATURE_DIR="$1"
STAGE="$2"
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

if ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not found" >&2
  exit 2
fi

EXTRA_INPUTS=""
case "$STAGE" in
  intake)
    INPUT_FILE="$FEATURE_DIR/request.txt"
    OUTPUT_FILE="$FEATURE_DIR/00-intake.md"
    SKILL_FILE="$ROOT_DIR/skills/sdd-intake/SKILL.md"
    ROLE_FILE="$ROOT_DIR/subagents/intake-writer.md"
    TEMPLATE_FILE="$ROOT_DIR/templates/00-intake.md"
    ;;
  spec)
    INPUT_FILE="$FEATURE_DIR/00-intake.md"
    OUTPUT_FILE="$FEATURE_DIR/01-spec.md"
    SKILL_FILE="$ROOT_DIR/skills/sdd-spec/SKILL.md"
    ROLE_FILE="$ROOT_DIR/subagents/spec-writer.md"
    TEMPLATE_FILE="$ROOT_DIR/templates/01-spec.md"
    ;;
  plan)
    INPUT_FILE="$FEATURE_DIR/01-spec.md"
    OUTPUT_FILE="$FEATURE_DIR/02-plan.md"
    SKILL_FILE="$ROOT_DIR/skills/sdd-plan/SKILL.md"
    ROLE_FILE="$ROOT_DIR/subagents/planner.md"
    TEMPLATE_FILE="$ROOT_DIR/templates/02-plan.md"
    ;;
  tasks)
    INPUT_FILE="$FEATURE_DIR/02-plan.md"
    OUTPUT_FILE="$FEATURE_DIR/06-tasks.md"
    SKILL_FILE="$ROOT_DIR/skills/sdd-tasks/SKILL.md"
    ROLE_FILE="$ROOT_DIR/subagents/task-decomposer.md"
    TEMPLATE_FILE="$ROOT_DIR/templates/06-tasks.md"
    ;;
  implement)
    INPUT_FILE="$FEATURE_DIR/06-tasks.md"
    OUTPUT_FILE="$FEATURE_DIR/07-implementation-log.md"
    SKILL_FILE="$ROOT_DIR/skills/sdd-implement/SKILL.md"
    ROLE_FILE="$ROOT_DIR/subagents/implementer.md"
    TEMPLATE_FILE="$ROOT_DIR/templates/07-implementation-log.md"
    EXTRA_INPUTS="$FEATURE_DIR/01-spec.md $FEATURE_DIR/02-plan.md"
    ;;
  validate)
    INPUT_FILE="$FEATURE_DIR/07-implementation-log.md"
    OUTPUT_FILE="$FEATURE_DIR/08-validation.md"
    SKILL_FILE="$ROOT_DIR/skills/sdd-validate/SKILL.md"
    ROLE_FILE="$ROOT_DIR/subagents/validator.md"
    TEMPLATE_FILE="$ROOT_DIR/templates/08-validation.md"
    EXTRA_INPUTS="$FEATURE_DIR/01-spec.md $FEATURE_DIR/02-plan.md $FEATURE_DIR/06-tasks.md"
    ;;
  *)
    echo "unsupported stage for Claude consumer: $STAGE" >&2
    exit 3
    ;;
esac

if [ ! -f "$INPUT_FILE" ]; then
  echo "missing input file: $INPUT_FILE" >&2
  exit 4
fi

for f in $EXTRA_INPUTS; do
  if [ ! -f "$f" ]; then
    echo "missing extra input file: $f" >&2
    exit 5
  fi
done

PROMPT_FILE="$FEATURE_DIR/.runtime/$STAGE.claude-prompt.txt"
mkdir -p "$FEATURE_DIR/.runtime"
cat > "$PROMPT_FILE" <<EOF
You are consuming a stage bundle for the lightweight SDD pipeline.

Your task: execute the '$STAGE' stage and write the output artifact.

Feature directory:
$FEATURE_DIR

Follow these instruction sources strictly:
1. Skill prompt: $SKILL_FILE
2. Subagent prompt: $ROLE_FILE
3. Template shape: $TEMPLATE_FILE
4. Primary input artifact: $INPUT_FILE
$(if [ -n "$EXTRA_INPUTS" ]; then printf '5. Additional context files: %s\n' "$EXTRA_INPUTS"; fi)

Requirements:
- Read the instruction files and the input artifact.
- Read any additional context files listed above.
- Produce exactly one markdown document for the target output.
- Write the result directly to: $OUTPUT_FILE
- Preserve markdown clarity.
- Do not modify any other files unless the stage explicitly requires repository changes.
- For the implement stage, you may modify repository files as needed for the bounded task scope, but you must also write the implementation log to the target output path.
- Do not ask follow-up questions; if ambiguity exists, capture it inside the output artifact according to the prompt rules.
EOF

claude --permission-mode acceptEdits --print "Read '$PROMPT_FILE' and perform the task exactly." >/tmp/claude-stage-consumer.log

echo "Claude consumer completed stage: $STAGE"
echo "Output file: $OUTPUT_FILE"
