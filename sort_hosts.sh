| awk -F'/' '{print $3, substr($0, index($0, $4))}' | sort | awk '
{
    if ($1 != prev_host) {
        if (NR > 1) print ""; # Blank line between host groups
        print $1;             # Print the hostname
        prev_host = $1;
    }
    print "/" $2;
}'





output: www.gstatic.com
/devrel-devsite/prod/v5ab6fd0ad9c02b131b4d387b5751ac2c3616478c6dd65b5e931f0805efa1009c/developers/css/app.css
/devrel-devsite/prod/v5ab6fd0ad9c02b131b4d387b5751ac2c3616478c6dd65b5e931f0805efa1009c/developers/css/app.css

etc
