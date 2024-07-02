#!/bin/bash

# Path to the files using the $HOME environment variable
MODS_FILE="$HOME/Library/Application Support/unity.Klei.Oxygen Not Included/mods/mods.json"
WORKSHOP_FILE="$HOME/Library/Application Support/Steam/steamapps/workshop/appworkshop_457140.acf"
MOD_FOLDER="$HOME/Library/Application Support/unity.Klei.Oxygen Not Included/mods/Steam"

# Check if the files exist
if [[ ! -f "$MODS_FILE" ]]; then
  echo "File $MODS_FILE not found."
  exit 1
fi

if [[ ! -f "$WORKSHOP_FILE" ]]; then
  echo "File $WORKSHOP_FILE not found."
  exit 1
fi

# Ensure the JQ is installed
if ! command -v jq &>/dev/null; then
  echo "jq is not installed. Please install it using brew install jq."
  exit 1
fi

# Extract mod IDs from the original mods.json
MOD_IDS=$(jq -r '.mods[].label.id' "$MODS_FILE")

# Modify mods.json to keep only the required mod and decrement its version
jq '{
  version: .version,
  mods: [
    {
      label: {
        distribution_platform: .mods[] | select(.label.id == "1843965353").label.distribution_platform,
        id: "1843965353",
        version: (.mods[] | select(.label.id == "1843965353").label.version - 1),
        title: (.mods[] | select(.label.id == "1843965353").label.title)
      },
      status: 1,
      enabled: true,
      crash_count: 0,
      reinstall_path: null
    }
  ]
}' "$MODS_FILE" >/tmp/mods_temp.json

# Move the temporary file to the original location
mv /tmp/mods_temp.json "$MODS_FILE"

# Function to delete blocks from the file using sed
delete_block() {
  local file=$1
  local id=$2
  local tmp_file="/tmp/temp_acf_file"
  awk -v id="$id" '
  BEGIN {block=0}
  {
    if ($0 ~ "\""id"\"") {block=1}
    if (!block) {print $0}
    if (block && $0 ~ /^[[:space:]]*\}/) {block=0}
  }' "$file" >"$tmp_file"
  mv "$tmp_file" "$file"
}

# Delete entries from appworkshop_457140.acf
for MOD_ID in $MOD_IDS; do
  echo "Deleting block for mod $MOD_ID"
  delete_block "$WORKSHOP_FILE" "$MOD_ID"
  echo "Deleting mod folder $MOD_FOLDER/$MOD_ID"
  rm -rf "$MOD_FOLDER/$MOD_ID"
done

echo "Files have been updated."
