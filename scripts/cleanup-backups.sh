
if [ "$#" -ne 1 ]; then
    echo "[Usage]: cleanup-backups.sh <backup folder> <max backups to keep>"
    exit 1
fi

MAX_BACKUPS=$2

NUMBER_OF_BACKUPS=$(find "$1" -maxdepth 1 -type d ! -path . | wc -l)
echo "$(date -u) Found $NUMBER_OF_BACKUPS backups"
while [ "$NUMBER_OF_BACKUPS" -ge "$MAX_BACKUPS" ]
do
    echo "$(date -u) Deleting oldest backup..."
    # Find oldest backup
    IFS= read -r -d $'\0' line < <(find "$1" -maxdepth 1 -type d -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
    OLDEST_FILE="${line#* }"

    echo "$(date -u) Found oldest backup: $OLDEST_FILE..."

    rm -rf "$OLDEST_FILE"

    echo "$(date -u) Deleted: $OLDEST_FILE."
    echo

    NUMBER_OF_BACKUPS=$(find "$1" -maxdepth 1 -type d ! -path . | wc -l)
    echo "$(date -u) Found $NUMBER_OF_BACKUPS backups"
done

echo "Done."

exit 0