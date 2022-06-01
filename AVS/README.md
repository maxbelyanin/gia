# AVS

## Monitoring

### /monitoring/sys

http://monitoring:Vjybnjhbyu@<HOST_IP>/monitoring/sys

Response:

- keys:
  - **pull** - local videostreaming
  - **push** - sharing videostreaming
  - **rec** - recording videostreaming
- values:
  - **""** - disable (*Выключено*)
  - **"RUNNING"** - enable and successfully running (*Трнаслируется/Включена*)
  - **"BACKOFF"** - enable and restarting (*Перезапускается*)
  - **STARTING** - enable and starting (*Запускается*)
- combinations:
  - **("pull")** - local view videostream (*ОВЗ включено*)
  - **("pull" + "push" )** - local view and share videostream (*Камера транслируется*)
  - **("pull" + "push" + "rec")** - local view, share and recording videostream (*Камера транслируется* + *Запись включена*)
  - **("pull" + "rec")** - local view, share and recording videostream (*ОВЗ включено* + *Запись включена*)

```json
{
  "name": "0124",
  "avsVersion": "0.4.11",
  "freeSpace": 7520464498688,
  "cams": {
    "cam_all": 23,
    "cam_rec_on": 0,
    "cam_rec_off": 23,
    "cam_rec_waiting": 0,
    "cam_proxy_on": 18,
    "cam_proxy_off": 1,
    "cam_proxy_waiting": 4
  },
  "cam_list": {
    "0124_1": {
      "name": "A-0000-0",
      "comment": "Вход",
      "remoteUrl": "rtsp:/10.103.120.66:5554/vod/0124_1",
      "playUrl": "rtsp://admin:admin54321@192.168.254.10:554/Streaming/Channels/101",
      "pull": "RUNNING",
      "push": "STARTING",
      "rec": "BACKOFF"
    },
    ...
  }
}
```

### /monitoring/rtsp

http://monitoring:Vjybnjhbyu@<HOST_IP>/monitoring/rtsp


```json
{
  "results": {
    "0107_1": {
      "name": "0107_1",
      "type": "INP",
      "online": true,
      "lastSeen": "2022-05-23T02:14:46.862177594+03:00",
      "ip": "11.103.100.131",
      "port": 5554,
      "playPort": 2935,
      "farIp": "11.103.100.131",
      "farPort": 55654,
      "creationTimestamp": 1653259150272.423,
      "upTime": 2136584.7908,
      "appname": "flvplayback",
      "title": "A-0000-0",
      "comment": "Вход",
      "audio": {
        "codec": "AUNK",
        "bytesCount": 0,
        "packetsCount": 0,
        "droppedBytesCount": 0,
        "droppedPacketsCount": 0
      },
      "video": {
        "codec": "VH264",
        "bytesCount": 1509091660,
        "packetsCount": 55690,
        "droppedBytesCount": 0,
        "droppedPacketsCount": 0
      },
      "pullSettings": {
        "localStreamName": "",
        "uri": ""
      }
    },
    ...
  },
  "num_results": 17,
  "page": 1,
  "total_pages": 1,
  "results_per_page": 17
}
```
