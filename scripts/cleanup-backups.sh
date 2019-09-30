#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "[Usage]: cleanup-backups.sh <backup folder> <max backups to keep>"
    exit 1
fi

MAX_BACKUPS=$2

NUMBER_OF_BACKUPS=$(find "$1" -maxdepth 1 -type d ! -path . | wc -l)
echo "$(date -u) Found $NUMBER_OF_BACKUPS backups"
while [ "$NUMBER_OF_BACKUPS" -ge "$MAX_BACKUPS" ]
do
    printf "$(date -u)\t%s\n" "Deleting oldest backup..."
    # Find oldest backup
    IFS= read -r -d $'\0' line < <(find "$1" -maxdepth 1 -type d -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
    OLDEST_FILE="${line#* }"

    printf "$(date -u)\t%s\n" "Found oldest backup: $OLDEST_FILE..."

    rm -rf "$OLDEST_FILE"

    printf "$(date -u)\t%s\n" "Deleted: $OLDEST_FILE."
    echo

    NUMBER_OF_BACKUPS=$(find "$1" -maxdepth 1 -type d ! -path . | wc -l)
    printf "$(date -u)\t%s\n" "Found $NUMBER_OF_BACKUPS backups"
done

printf "$(date -u)\t%s\n" "Done."

exit 0