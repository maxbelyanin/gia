#!/bin/sh

#jsontags='[
#    {"tag":"avs_stream_action", "value":"pull_off"},
#    {"tag":"avs_stream_action", "value":"rec_off"},
#    {"tag":"avs_stream_action", "value":"pull_on"},
#    {"tag":"avs_stream_action", "value":"rec_on"},
#    {"tag":"avs_stream_name", "value":"0124_1"},
#    {"tag":"avs_stream_uri", "value":"rtsp://admin:admin54321@192.168.254.10:554/Streaming/Channels/101"},
#    {"tag":"avs_stream_title", "value":"A-0000-0"},
#    {"tag":"avs_stream_comment", "value":"Вход"},
#    {"tag":"avs_stream_ovz", "value":"false"}
#]'

#jsontags='[ {"tag":"avs_stream_action", "value":"pull_del"}, {"tag":"avs_stream_action", "value":"rec_del"}, {"tag":"avs_stream_action", "value":"pull"}, {"tag":"avs_stream_action", "value":"rec"}, {"tag":"avs_stream_name", "value":"0124_1"}, {"tag":"avs_stream_uri", "value":"rtsp://admin:admin54321@192.168.254.10:554/Streaming/Channels/101"}, {"tag":"avs_stream_title", "value":"A-0000-0"}, {"tag":"avs_stream_comment", "value":"Вход"}, {"tag":"avs_stream_ovz", "value":"false"} ]'
jsontags='[ {"tag":"avs_stream_action", "value":"pull_off"}, {"tag":"avs_stream_name", "value":"0124_1"} ]'

#jsontags='[ {"tag":"avs_stream_action", "value":"rec_on"}, {"tag":"avs_stream_name", "value":"0124_1"}, {"tag":"avs_stream_uri", "value":"rtsp://admin:admin54321@192.168.254.10:554/Streaming/Channels/101"}, {"tag":"avs_stream_title", "value":"A-0000-0"}, {"tag":"avs_stream_comment", "value":"Вход"}, {"tag":"avs_stream_ovz", "value":"false"} ]'

rec_off=$(echo $jsontags | jq 'any (.[]; .tag=="avs_stream_action" and .value=="rec_off")')
pull_off=$(echo $jsontags | jq 'any (.[]; .tag=="avs_stream_action" and .value=="pull_off")')
pull_on=$(echo $jsontags | jq 'any (.[]; .tag=="avs_stream_action" and .value=="pull_on")')
rec_on=$(echo $jsontags | jq 'any (.[]; .tag=="avs_stream_action" and .value=="rec_on")')

stream_name=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_name") | .value')
stream_uri=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_uri") | .value')
stream_title=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_title") | .value')
stream_comment=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_comment") | .value')
stream_ovz=$(echo $jsontags | jq '.[] | select(.tag=="avs_stream_ovz") | .value == "true"')

## if need to /rec/del
if [ "$rec_off" = true ] || [ "$pull_off" = true ]; then
echo "'["$stream_name"]'" |  xargs curl -X POST -H "Content-Type: application/json" --url "http://monitoring:Vjybnjhbyu@10.103.120.66/monitoring/rec/del" -d
fi

# if need to /pull/del
if [ "$pull_off" = true ]; then
echo "'["$stream_name"]'" |  xargs curl -X POST -H "Content-Type: application/json" --url "http://monitoring:Vjybnjhbyu@10.103.120.66/monitoring/pull/del" -d
fi

## pause between stopping and starting
if [ "$rec_off" = true ] || [ "$pull_off" = true ]; then
sleep 5
fi

# if need to /pull
if [ $pull_on = true ] || [ $rec_on = true ]; then
echo "'["{\"uri\": $stream_uri, \"streamName\": $stream_name, \"title\": $stream_title, \"comment\": $stream_comment, \"OVZ\": $stream_ovz}"]'" |  xargs curl -X PUT -H "Content-Type: application/json" --url "http://monitoring:Vjybnjhbyu@10.103.120.66/monitoring/pull" -d
fi

# if need to /rec
if [ $rec_on = true ]; then
echo "'["{\"streamName\": $stream_name, \"title\": $stream_title, \"uriRec\": \"\", \"limitSec\": 0, \"segmentSec\": 1800}"]'" |  xargs curl -X PUT -H "Content-Type: application/json" --url "http://monitoring:Vjybnjhbyu@10.103.120.66/monitoring/rec" -d
fi

