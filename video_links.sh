#!/usr/bin/env bash
# Prints to stdout the Markdown-formatted links for all the videos/resources
# that are in the remote /clear/www/htdocs/comp412/Support/ directory. Useful
# for copy-pasting to Piazza Markdown editor.
# Usage: ./video_md_links.sh [-n | --netid <netid>] [-p | --plain]
# Options:
#   -n, --netid <netid>      Your netid on the CLEAR server
#   -p, --plain              Print plain text links instead of Markdown
#   -h, --help               Print this help message
#
# Author: Micah Kepe <mik3@rice.edu>
# Date: 2025-10-20

NETID="mik3"
BASEURL="https://www.clear.rice.edu/comp412/Support/"
REMOTE_URL="ssh.clear.rice.edu"
REMOTE_DIR="/clear/www/htdocs/comp412/Support/"
PLAIN=false

print-usage() {
  echo "Usage: ./video_md_links.sh [-n | --netid <netid>] [-p | --plain]"
  echo "Options:"
  echo "  -n, --netid <netid>      Your netid on the CLEAR server"
  echo "  -p, --plain              Print plain text links instead of Markdown"
  echo "  -h, --help               Print this help message"
}

while [[ $# -gt 0 ]]; do
  case $1 in
  -n | --netid)
    NETID="$2"
    shift
    ;;
  -p | --plain)
    PLAIN=true
    ;;
  -h | --help)
    print-usage
    exit 0
    ;;
  *)
    echo "Unknown argument: $1"
    exit 1
    ;;
  esac
  shift
done

rsync -rn --list-only "$NETID@$REMOTE_URL:$REMOTE_DIR" | while read -r line; do
  path=$(echo "$line" | awk '{print $5}')
  url="$BASEURL$path"

  if [[ "$PLAIN" == true ]]; then
    echo "$url"
  else
    echo "[$path]($url)"
  fi
done
