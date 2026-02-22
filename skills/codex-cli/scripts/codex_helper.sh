#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
codex_helper.sh - quick Codex CLI helper

Usage:
  codex_helper.sh check
  codex_helper.sh interactive [prompt]
  codex_helper.sh exec <prompt>
  codex_helper.sh resume-last [prompt]

Examples:
  codex_helper.sh check
  codex_helper.sh interactive "Explain this repository"
  codex_helper.sh exec "Fix lint errors"
  codex_helper.sh resume-last "Continue with test fixes"
EOF
}

need_codex() {
  if ! command -v codex >/dev/null 2>&1; then
    echo "codex not found. Install with: npm i -g @openai/codex" >&2
    exit 1
  fi
}

cmd="${1:-}"
case "$cmd" in
  check)
    need_codex
    codex --version
    ;;
  interactive)
    need_codex
    shift || true
    if [ "$#" -gt 0 ]; then
      codex "$*"
    else
      codex
    fi
    ;;
  exec)
    need_codex
    shift || true
    if [ "$#" -eq 0 ]; then
      echo "Missing prompt for exec" >&2
      usage
      exit 2
    fi
    codex exec "$*"
    ;;
  resume-last)
    need_codex
    shift || true
    if [ "$#" -gt 0 ]; then
      codex exec resume --last "$*"
    else
      codex resume --last
    fi
    ;;
  ""|-h|--help|help)
    usage
    ;;
  *)
    echo "Unknown command: $cmd" >&2
    usage
    exit 2
    ;;
esac
