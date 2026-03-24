#!/bin/zsh

# Function to HTML-escape special characters
# This function is designed to handle common HTML special characters.
# For robust, full-fledged HTML escaping (e.g., for user-generated content
# that might contain malicious scripts), you would typically use a more
# comprehensive tool or programming language.
html_escape() {
  local s="$1"
  s="${s//&/&amp;}" # Must be first!
  s="${s//</&lt;}"
  s="${s//>/&gt;}"
  s="${s//\"/&quot;}"
  s="${s//\'/&#39;}" # Single quote is less critical but good practice
  echo "$s"
}

# Read stdin
my_stdin=$(cat)

# Create a temporary directory if it doesn't exist.
# =================================================
TMP_PATH="/tmp/ff_from_stdin"
if [ ! -d "$TMP_PATH" ]; then
  mkdir -p "$TMP_PATH"
fi

# Remove any temporary files older than a day.
find "$TMP_PATH" -type f -mtime +1 -name 'ff-*.html' -exec rm -- '{}' \;

# Create a temporary file and set a trap to clean it up.
# ======================================================
TMP_FILE=$(mktemp "$TMP_PATH/ff-XXXXXX.html") || {
  echo "Failed to create temp file!"
  exit 1
}
trap 'rm -f "$TMP_FILE"' EXIT INT TERM

# Build an HTML page around $my_stdin and pass it to Firefox.
# ===========================================================
CSS=$(
  cat <<-END
div.jlc {
  font-size: 1.6em;
  font-family: "Source Han Sans", "源ノ角ゴシック", "Hiragino Sans", "HiraKakuProN-W3", "Hiragino Kaku Gothic ProN W3", "Hiragino Kaku Gothic ProN", "ヒラギノ角ゴ ProN W3", "Noto Sans", "Noto Sans CJK JP", "メイリオ", Meiryo, "游ゴシック", YuGothic, "ＭＳ Ｐゴシック", "MS PGothic", "ＭＳ ゴシック", "MS Gothic", sans-serif;
}
END
)

# Apply HTML escaping *before* replacing newlines with <br/>
escaped_stdin=$(html_escape "$my_stdin")
content="${escaped_stdin//$'\n'/<br/>}"

# Use printf for better control over string output, especially with potential complex characters
printf "%s\n" "<!DOCTYPE html><html><head><style>${CSS}</style></head><body><div class=\"jlc\">${content}</div></body></html>" >"$TMP_FILE"

# --- CHANGE THIS LINE TO SPECIFY FIREFOX DEVELOPER EDITION ---
FIREFOX_BIN="/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox"

# Check if Firefox Dev Edition exists before trying to launch it
if [[ ! -x "$FIREFOX_BIN" ]]; then
  echo "Error: Firefox Developer Edition not found at '$FIREFOX_BIN'." >&2
  echo "Please check the path or ensure it's installed." >&2
  exit 1
fi

# Open the HTML file in a new Firefox window.
# Ensure firefox is in your PATH. If not, use the full path, e.g., /Applications/Firefox.app/Contents/MacOS/firefox
"$FIREFOX_BIN" -new-window "file://${TMP_FILE}" >/dev/null 2>&1 &

# Give Firefox a moment to open before exiting the script.
sleep 1

exit 0
