#!/bin/sh

stream_uri=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_uri") | .value')
stream_name=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_name") | .value')
stream_title=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_title") | .value')
stream_comment=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_comment") | .value')
stream_ovz=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_ovz") | .value == "true"')
echo "'["{\"uri\": $stream_uri, \"streamName\": $stream_name, \"title\": $stream_title, \"comment\": $stream_comment, \"OVZ\": $stream_ovz}"]'" |  xargs curl -X PUT -H "Content-Type: application/json" --url "http://monitoring:Vjybnjhbyu@10.103.120.66/monitoring/pull" -d
