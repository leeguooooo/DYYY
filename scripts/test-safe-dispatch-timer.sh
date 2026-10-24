#!/bin/bash
set -euo pipefail

repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
test_dir="$(mktemp -d "${TMPDIR:-/tmp}/dyyy-timer-tests.XXXXXX")"
trap 'rm -rf "$test_dir"' EXIT

# 使用 macOS Foundation 单独验证定时器生命周期，无需 Theos 或连接手机。
xcrun --sdk macosx clang \
    -fobjc-arc -fsanitize=address -g -O1 -framework Foundation \
    -I "$repo_dir" \
    "$repo_dir/tests/AWMSafeDispatchTimerTests.m" \
    "$repo_dir/AWMSafeDispatchTimer.m" \
    -o "$test_dir/timer-tests"
"$test_dir/timer-tests"
