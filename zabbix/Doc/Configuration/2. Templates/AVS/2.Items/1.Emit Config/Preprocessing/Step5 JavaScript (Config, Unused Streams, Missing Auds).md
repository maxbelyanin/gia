# Step5 JavaScript (Config, Unused Streams, Missing Auds)

- [Step5 JavaScript (Config, Unused Streams, Missing Auds)](#step5-javascript-config-unused-streams-missing-auds)
  - [Processor](#processor)
  - [Output Value](#output-value)

## Processor

```js
//=============================================================================
// AVS CONFIG; UNUSED STREAMS; MISSING AUDS
var src = JSON.parse(value);

var ppe_config = {
    "involved_dates": src.involved_dates,
    "unused_streams": [],
    "missing_auds": [],
    "streams": {}
};

var missing_auds_dict = {};
for (var a in src.involved_auds) missing_auds_dict[a]="";

for (var stream_id in src.cam_list) {
    var curr_aud_code = src.cam_list[stream_id]["name"].substr(2,4)
    if (src.involved_auds.hasOwnProperty(curr_aud_code)) {
        delete missing_auds_dict[curr_aud_code];
        
        ppe_config.streams[stream_id] = {
            "aud_code":     curr_aud_code,
            "exam_dates":   JSON.parse(JSON.stringify(src.involved_auds[curr_aud_code])),
            "avs_name":     src.cam_list[stream_id]["name"],
            "id":           Number(stream_id.substr(5)),
            "zbx_id":       src.ppe_code + "_" + curr_aud_code + "_" + src.cam_list[stream_id]["name"].substr(7,1) + "_" + stream_id.substr(5),
            "comment":      src.cam_list[stream_id]["comment"],
            "cam_url":      src.cam_list[stream_id]["playUrl"]
        }
    } else {
        ppe_config.unused_streams.push(stream_id)
    }
}

for (var k in missing_auds_dict) ppe_config.missing_auds.push(k)

return JSON.stringify(ppe_config)
```

## Output Value

```json
{
    "involved_dates": {
        "2022-03-12": {
            "0000": [1,0],
            "7777": [1,0],
            "0003": [1,0],
            ...
        },
        ...
    },
    "unused_streams":       ["0000_1"],
    "missing_auds":         ["0001"],
    "streams": {
        "aud_code":         "0002",
        "exam_dates": {
            "2022-03-12":   ["07-06-2022", 1, 0]
            ...
        },
        "avs_name":         "A-0002-0",
        "id":               4,
        "zbx_id":           "0124_0002_0_4",
        "comment":          "Кабинет Физики",
        "cam_url":          "rtsp://admin:admin54321@192.168.254.23:554/Streaming/Channels/101"
    }
}
```
