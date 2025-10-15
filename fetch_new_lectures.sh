#!/usr/bin/env bash
# Fetches new lectures from the CLEAR server
# Usage: ./fetch_new_lectures.sh [-n|--netid <netid>] [-i|--include-videos] [-h|--help]
# Options:
#   -n, --netid <netid>      Your netid on the CLEAR server
#   -i, --include-videos     Include videos from the lecture directory
#   -h, --help               Print this help message
# ------------------------------------------------------------------------------
# Author: Micah Kepe <mik3@rice.edu>
# Date: 2025-10-15
# ------------------------------------------------------------------------------
NETID="mik3"
INCLUDE_VIDEOS="false"

print-usage() {
  echo "Usage: $0 [-n|--netid <netid>] [-i|--include-videos] [-h|--help]"
  echo ""
  echo "Options:"
  echo "  -n, --netid <netid>      Your netid on the CLEAR server"
  echo "  -i, --include-videos     Include videos from the lecture directory"
  echo "  -h, --help               Print this help message"
  echo ""
}

while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  -n | --netid)
    NETID="$2"
    shift
    shift
    ;;
  -i | --include-videos)
    INCLUDE_VIDEOS="true"
    shift
    ;;
  -h | --help)
    print-usage
    exit
    ;;
  *)
    echo "Unknown option $1"
    echo ""
    print-usage
    exit 1
    ;;
  esac
done

VIDEO_OPTION=(--exclude '*.mp4')
if [ "$INCLUDE_VIDEOS" = "true" ]; then
  VIDEO_OPTION=()
fi

# Lectures (save to local "Lectures")
rsync -av --ignore-existing "${VIDEO_OPTION[@]}" "$NETID"@ssh.clear.rice.edu:/clear/www/htdocs/comp412/Support/Lectures/ Lectures

# Supplemental lectures (save to local "Supplemental")
rsync -av --ignore-existing "$NETID"@ssh.clear.rice.edu:/clear/www/htdocs/comp412/Support/ --exclude 'Lectures/' "${VIDEO_OPTION[@]}" Supplemental
