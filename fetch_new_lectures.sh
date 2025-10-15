#!/usr/bin/env bash
NETID="mik3"

# Lectures (save to local "Lectures")
rsync -av --ignore-existing --exclude '*.mp4' "$NETID"@ssh.clear.rice.edu:/clear/www/htdocs/comp412/Support/Lectures/* Lectures

# Supplemental lectures (save to local "Supplemental")
rsync -av --ignore-existing "$NETID"@ssh.clear.rice.edu:/clear/www/htdocs/comp412/Support/* --exclude 'Lectures/' --exclude '*.mp4' Supplemental

