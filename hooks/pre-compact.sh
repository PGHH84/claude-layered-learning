#!/bin/bash
# Auto-generate diary entry before Claude Code compacts conversation
# This hook runs before compact operations (while full context is still available)
# Output is fed back to Claude, which sees /diary and runs the command
echo "Auto-generating diary entry before compact..."
echo "/diary"
