# Function to rsync files from remote server
rsync_file() {
    local user="ubuntuuser"                  # target user to login with
    local filehost="<target.net>"            # target webserver listening on 22 for rsync
    local filepath="/dev/shm/${1}"           # Dir where the files you want to d/l sync are located

    # Ensure a filename argument is provided
    if [[ -z "$1" ]]; then
        echo "Usage: rsync_file <filename>"
        return 1
    fi

    # Run rsync with provided user, host, and file path
    rsync -avP -e ssh "$user@$filehost:$filepath" .
}

# Usage example:
# rsync_file "The.Penguin.S01E06.1080p.WEB.h264-ETHEL.mkv"  be careful using wildcards


