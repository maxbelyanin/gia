#!/bin/sh

stream_name=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_name") | .value')
stream_uri=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_uri") | .value')
stream_title=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_title") | .value')
stream_comment=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_comment") | .value')
stream_ovz=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_ovz") | .value == "true"')
echo "'["{\"uri\": $stream_uri, \"streamName\": $stream_name, \"title\": $stream_title, \"comment\": $stream_comment, \"OVZ\": $stream_ovz}"]'" |  xargs curl -X PUT -H "Content-Type: application/json" --url "http://monitoring:Vjybnjhbyu@localhost/monitoring/pull" -d
echo "'["{\"streamName\": $stream_name, \"title\": $stream_title, \"uriRec\": \"\", \"limitSec\": 0, \"segmentSec\": 1800}"]'" |  xargs curl -X PUT -H "Content-Type: application/json" --url "http://monitoring:Vjybnjhbyu@localhost/monitoring/rec" -d
