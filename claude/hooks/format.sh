#!/bin/bash

file_path=$(jq -r '.tool_input.file_path')

case "$file_path" in
  *.ts|*.tsx|*.js|*.jsx)
    pnpm format
    pnpm typecheck
    pnpm lint
    ;;
esac
