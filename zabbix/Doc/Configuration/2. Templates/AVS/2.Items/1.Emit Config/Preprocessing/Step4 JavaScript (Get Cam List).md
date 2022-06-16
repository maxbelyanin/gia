# Step4 JavaScript (Get Cam List)

- [Step4 JavaScript (Get Cam List)](#step4-javascript-get-cam-list)
  - [Processor](#processor)
  - [Output Value](#output-value)

## Processor

```js
//=============================================================================
// GET CAM LIST
var result = JSON.parse(value);

var request = new HttpRequest();
var response = request.get("{$AVS_URL_MONITORING_SYS}");
var response_obj = JSON.parse(response)

result["cam_list"] = response_obj.cam_list;
result["ppe_code"] = response_obj.name;

return JSON.stringify(result);
```

## Output Value

```json
{
    "ppe_code": "0124",
    "involved_dates": {
        "2022-03-12": {
            "0000": [1,0],
            "7777": [1,0],
            "0003": [1,0],
            ...
        },
        ...
    },
    "involved_auds": {
        "0000": {
            "2022-03-12": ["07-06-2022", 1, 0]
            ...
        },
        ...
    },
    "cam_list": {
        "0124_1":{
            "name":"A-0000-0",
            "comment":"Вход",
            "remoteUrl":"rtsp:/10.103.120.66:5554/vod/0124_1",
            "playUrl":"rtsp://admin:admin54321@192.168.254.10:554/Streaming/Channels/101",
            "pull":"RUNNING",
            "push":"RUNNING",
            "rec":"RUNNING"
        },
        ...
    }
}
```
