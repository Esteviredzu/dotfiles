#!/bin/bash

echo "⚠️  WARNING: The contents of ~/.config will be overwritten."
echo "Make sure you have backed up anything important."
read -p "Continue? (y/N): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    for d in */; do
        cp -r "$d" ~/.config/
    done
    echo "✅ Directories have been copied to ~/.config"
else
    echo "❌ Operation cancelled."
fi
