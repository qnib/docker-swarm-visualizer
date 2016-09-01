#!/bin/bash
set -e

CHECK_URL=localhost:${PORT}
echo "curl -sI ${CHECK_URL}"
curl -sI ${CHECK_URL}
