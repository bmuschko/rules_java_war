#!/usr/bin/env bash

# Verify that WAR file has been created
EXPECTED_WAR_FILE="$1"

if [ ! -f "$EXPECTED_WAR_FILE" ]; then
  echo "Expected WAR file $expected_war_file to exist"
  exit 1
fi

# Verify WAR file contents
EXPECTED_WAR_CONTENTS="WEB-INF/web.xml
css/style.css
index.html
js/dynamic.js
WEB-INF/lib/liblibcompression.jar"
ACTUAL_WAR_CONTENTS="$(jar -tf $EXPECTED_WAR_FILE)"

if [ "$EXPECTED_WAR_CONTENTS" != "$ACTUAL_WAR_CONTENTS" ]; then
  echo "Expected WAR file contents '$EXPECTED_WAR_CONTENTS', got '$ACTUAL_WAR_CONTENTS'"
  exit 1
fi

# Verify WAR file size
EXPECTED_WAR_SIZE="1458"
ACTUAL_WAR_SIZE="$(wc -c $EXPECTED_WAR_FILE | awk '{print $1}')"

if [ "$EXPECTED_WAR_SIZE" != "$ACTUAL_WAR_SIZE" ]; then
  echo "Expected WAR file size '$EXPECTED_WAR_SIZE', got '$ACTUAL_WAR_SIZE'"
  exit 1
fi