#!/bin/bash
cd "$(dirname "$0")"
npx serve . &
sleep 2
if command -v xdg-open &>/dev/null; then
  xdg-open http://localhost:3000
elif command -v open &>/dev/null; then
  open http://localhost:3000
fi
