#!/bin/sh

stream_name=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_name") | .value')
echo "'["$stream_name"]'" |  xargs curl -X POST -H "Content-Type: application/json" --url "http://monitoring:Vjybnjhbyu@localhost/monitoring/rec/del" -d
