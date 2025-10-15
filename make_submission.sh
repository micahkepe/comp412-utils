#!/bin/bash

# Description: Make a tar archive for lab source code and timestamped backups
#
# Usage: ./make_submission.sh <source directory> [-l | --lab] <lab-num>
#
# Options:
#   -l, --lab <lab-num>  Lab number
#   -h, --help           Print help
#
# Example: ./make_submission.sh ~/comp412/lab-1 -l 1
#
# Effects:
#   - Creates a tar archive of the source code in the current directory
#   - Creates a timestamped backup of the source code in the submissions
#     directory
#   - NOTE: will overwrite the <netid>.tar archive if it already exists, but
#     all backups will be preserved
#
# Author: Micah Kepe <mik3@rice.edu>
# Date: 2025-09-04

DIR=""
USER=$(whoami)
LAB=""

# Exclude patterns for tar archive
EXCLUDE_PATTERNS=(
  "*.log"
  "zill412"
  "target"
  ".git"
  ".gitignore"
  "tests"
  ".github"
)

print-usage() {
  echo "Usage: ./make_submission.sh <source directory> [-l | --lab] <lab-num>"
  echo "  <source directory>	Directory containing the source code"
  echo "  -l, --lab 		Lab number"
  echo "  -h, --help		Print help"
}

print-error() {
  echo "Error:" "$@" >&2
}

if [[ $# -eq 0 ]]; then
  print-usage
  exit 1
fi

while [[ "$#" -gt 0 ]]; do
  case "$1" in
  -h | --help)
    print-usage
    exit 0
    ;;
  -l | --lab)
    if [[ -n "$2" && ! "$2" =~ ^- ]]; then
      LAB="$2"
      shift 2
    else
      print-error "Lab number must be positive integer after -l/--lab"
      print-usage
      exit 1
    fi
    ;;
  *)
    if [[ -z "$DIR" ]]; then
      DIR="$1"
      shift
    else
      print-error "Unknown option or argument: $1"
      print-help
      exit 1
    fi
    ;;
  esac
done

if [[ -z "$DIR" ]]; then
  print-error "Source directory is required"
  print-usage
  exit 1
fi

if [[ -z "$LAB" ]]; then
  print-error "Lab number is required"
  print-usage
  exit 1
fi

if ! [[ "$LAB" =~ ^[0-9]+$ ]]; then
  print-error "Lab number is not a valid positive integer"
  print-usage
  exit 1
fi

cd "$DIR" || {
  print-error "Invalid directory path"
  exit 1
}

echo "========================================================================="
echo ""
echo "Checking Makefile targets work"
echo ""

echo "make clean:"
make clean || {
  print-error "'make clean' failed, rewrite clean instructions before submitting"
  exit 1
}

echo ""

echo "make build:"
make build || {
  print-error "'make build' failed, rewrite build instructions before submitting"
  exit 1
}

echo ""
echo "========================================================================="
echo ""
echo "Creating tar archive and timestamped backup"
echo ""

OUTPUT_DIR=$HOME/comp412/submissions/lab-"$LAB"
TIMESTAMPED_DIR=$OUTPUT_DIR/backups
mkdir -p "$OUTPUT_DIR"
mkdir -p "$TIMESTAMPED_DIR"

TAR_FILE="$OUTPUT_DIR/$USER.tar"
tar cvf "$TAR_FILE" "${EXCLUDE_PATTERNS[@]/#/--exclude=}" . || {
  print-error "Failed to create tar archive '$TAR_FILE'"
  exit 1
}

echo ""
echo "Submission tar archive created successfully: $OUTPUT_DIR/$USER.tar"

# Create timestamped backup
BACKUP_FILE="$TIMESTAMPED_DIR/${USER}_$(date +%Y-%m-%d_%H-%M-%S).tar"
cp "$TAR_FILE" "$BACKUP_FILE" || {
  print-error "Failed to create backup archive '$BACKUP_FILE'"
  exit 1
}
echo "Backup created successfully: $BACKUP_FILE"

echo "========================================================================="
echo ""
echo "Yippee! Ok now submit:"
echo ""
echo "  ~comp412/bin/submit_$LAB $OUTPUT_DIR/$USER.tar"
echo ""
