#! /bin/bash
echo
# check jq is installed
if ! command -v jq &>/dev/null; then
    echo "jq is not installed. Please install jq first (https://github.com/jqlang/jq)."
    exit 1
fi


# usage: jwtreader <jwt> <jwt-part[being 0 or 1]>
if (($# < 1)); then
    echo "Usage:"
    echo "jwtreader <jwt> <jwt-part-index[being 0 or 1, default 1]>"
    echo "(It may be easier to first store the jwt token into a variable and then pass it to the script, or pass it with quotes. e.g. jwtreader \"-the-entire-token-\")"
    exit 1
fi

PART="1"
if (($# > 1)); then
    PART="$2"
fi

# verify the value of PART is either 0 or 1
if [[ "$PART" != "0" && "$PART" != "1" ]]; then
    echo "Invalid value for jwt-part-index. It should be either 0 or 1"
    exit 1
fi

jq -R 'gsub("-";"+") | gsub("_";"/") | split(".") | .['$PART'] | @base64d | fromjson' <<<"$1"
# capture error in the previous line and if so say "Invalid JWT token"
if [ $? -ne 0 ]; then
    echo
    echo "Invalid JWT token"
    exit 1
fi
echo
