#!/bin/bash
echo "H4-STDOUT produced output before failing"
echo "H4-STDERR error detail written to stderr" >&2
exit 3
