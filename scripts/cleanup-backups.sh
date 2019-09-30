
NUMBER_OF_BACKUPS=$(find . -maxdepth 1 -type d ! -path . | wc -l)

echo "$(date -u) Found $NUMBER_OF_BACKUPS backups"

if [ "$NUMBER_OF_BACKUPS" -ge 12 ]; then
    echo "$(date -u) Deleting oldest backup..."
    # Find oldest backup
    IFS= read -r -d $'\0' line < <(find . -maxdepth 1 -type d -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
    OLDEST_FILE="${line#* }"

    echo "$(date -u) Found oldest backup: $OLDEST_FILE..."

    rm -rf $OLDEST_FILE

    echo "$(date -u) Deleted: $OLDEST_FILE. Done"

    exit 1
fi