#!/bin/sh

stream_name=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_name") | .value')
echo "'["$stream_name"]'" |  xargs curl -X POST -H "Content-Type: application/json" --url "http://monitoring:Vjybnjhbyu@10.103.120.66/monitoring/rec/del" -d
echo "'["$stream_name"]'" |  xargs curl -X POST -H "Content-Type: application/json" --url "http://monitoring:Vjybnjhbyu@10.103.120.66/monitoring/pull/del" -d
