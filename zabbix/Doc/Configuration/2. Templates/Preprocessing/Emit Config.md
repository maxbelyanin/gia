# Emit Config

- [Emit Config](#emit-config)
  - [Step 1. JSONPath](#step-1-jsonpath)
  - [Step 2. JavaScript](#step-2-javascript)
  - [Step 3](#step-3)

## Step 1. JSONPath

```js
$.[?(@.PPECode=='{$GIA_PPE_CODE}')]
```

## Step 2. JavaScript

```js
// PPE CONFIG (AVS; INVOLVED DATES, AUDS; UNUSED STREAMS; MISSING AUDS)
var scheduler = JSON.parse(value);

//=============================================================================
// INVOLVED DATES
var involved_dates = {};

for (var i in scheduler) {
    var dat = scheduler[i]["Date"];
    var aud = scheduler[i]["AudienceCode"];
    if (!involved_dates.hasOwnProperty(dat)) { involved_dates[dat] = {"0000": [1,0], "7777": [1, 0]}; }
    involved_dates[dat][aud] = [Number(scheduler[i]["Online"]), Number(scheduler[i]["OVZ"])];
}

//=============================================================================
// INVOLVED AUDS
var involved_auds = {};

for (var curr_date in involved_dates) {
    for (var curr_aud in involved_dates[curr_date]) {
        if (!involved_auds.hasOwnProperty(curr_aud)) {
            involved_auds[curr_aud] = {
                "ppe": "{$GIA_PPE_CODE}",
                "aud": curr_aud,
                "exam": [],
                "MISSING_IN_AVS_CONFIG": "!!!!!!!!!!!!!!!!!!!!!!!!!"
            }
        }
        involved_auds[curr_aud]["exam"].push({
            "yd": curr_date,
            "dy": curr_date.replace(/(\d{4})-(\d{2})-(\d{2})/, "$3-$2-$1"),
            "online": 1,
            "ovz": 1
        })
    }
}

//=============================================================================
// AVS CONFIG; UNUSED STREAMS; MISSING AUDS

var request = new HttpRequest();
var response = request.get("{$AVS_URL_MONITORING_SYS}");
var cam_list = JSON.parse(response).cam_list;

var avs_config = {};
var unused_streams = [];


for (var stream_id in cam_list) {
    var curr_aud = cam_list[stream_id]["name"].substr(2,4)
    if (involved_auds.hasOwnProperty(curr_aud)) {
        delete involved_auds[curr_aud]["MISSING_IN_AVS_CONFIG"];
        avs_config[stream_id]               = involved_auds[curr_aud];
        avs_config[stream_id]["name"]       = cam_list[stream_id]["name"];
        avs_config[stream_id]["id"]         = Number(i.substr(5));
        avs_config[stream_id]["stream_id"]  = stream_id;
        avs_config[stream_id]["zbx_id"]    = involved_auds[curr_aud]["ppe"] + "_" + involved_auds[curr_aud]["aud"] + "_" + cam_list[stream_id]["name"].substr(7,1) + "_" + stream_id.substr(5);
        avs_config[stream_id]["comment"]    = cam_list[stream_id]["comment"];
        avs_config[stream_id]["payload"]    = {
            "push": {
                "uri":          cam_list[stream_id]["playUrl"],
                "streamName":   stream_id,
                "title":        cam_list[stream_id]["name"],
                "comment":      cam_list[stream_id]["comment"],
                "OVZ":          false
            },
            "rec":  {
                "streamName":   stream_id,
                "uriRec":       "",
                "limitSec":     0,
                "segmentSec":   1800,
                "title":        cam_list[stream_id]["name"],
                "comment":      cam_list[stream_id]["comment"],
                "OVZ":          false
            },
            "del":              [stream_id]
        }
    } else {
        unused_streams.push(stream_id);
    }
}

var missing_auds = []

for (var curr_aud in involved_auds){
    if(involved_auds[curr_aud].hasOwnProperty("MISSING_IN_AVS_CONFIG")) {
        missing_auds.push(curr_aud);
    }
}

//=============================================================================
// CURRENT EXAM DATE; NEXT EXAM DATE

function formatDate(date) {
  return date.getFullYear() + "-" + ("00" + (date.getMonth() + 1)).substr(-2) + "-" + ("00" + date.getDate()).substr(-2)
}

function formatDateDY(date) {
  return ("00" + date.getDate()).substr(-2) + "-"  + ("00" + (date.getMonth() + 1)).substr(-2) + "-" + date.getFullYear()
}

var exam_date_list = []
for (var date in involved_dates) {
  exam_date_list.push(date)
}
exam_date_list.sort()

//var now = new Date("2022-06-09" + "T09:00:00.000+03:00")
var now = new Date()

var exam_date = {
  days_next: -1,
  date_next: "",
  date_exam: {"yd": "", "dy": ""}
}

for (var i in exam_date_list) {
  var curr_exam_date = new Date(exam_date_list[i] + "T00:00:00.000+03:00")
  var curr_date_diff = now.getTime() - curr_exam_date.getTime()

  if (curr_date_diff < 0) {
    exam_date["days_next"] = (Math.abs(curr_date_diff) - (Math.abs(curr_date_diff) % 86400000)) / 86400000 + 1;
    exam_date["date_next"] = formatDate(curr_exam_date);
    break;
  } else if (curr_date_diff < 86400000) {
    exam_date["date_exam"]["yd"] = formatDate(curr_exam_date);
    exam_date["date_exam"]["dy"] = formatDateDY(curr_exam_date);
  }
}

ppe_config = {
    "exam_date":        exam_date,
    "involved_dates":   involved_dates,
    "involved_auds":    involved_auds,
    "unused_streams":   unused_streams,
    "missing_auds":     missing_auds,
    "avs_config":       avs_config,
}

return JSON.stringify(ppe_config);
```

## Step 3

retrun value:

```json
{
  "exam_date": {
    "days_next": 2,
    "date_next": "2022-06-15",
    "date_exam": {
      "yd": "",
      "dy": ""
    }
  },
  "involved_dates": {
    "2022-05-23": {
      "7777": [
        1,
        0
      ],
      ...
    },
    ...
  },
  "involved_auds": {
    "7777": {
      "ppe": "0124",
      "aud": "7777",
      "exam": [
        {
          "yd": "2022-05-23",
          "dy": "23-05-2022",
          "online": 1,
          "ovz": 1
        },
        ...
      ],
      "name": "A-7777-1",
      "id": 0,
      "stream_id": "0124_3",
      "zabx_id": "0124_7777_1_3",
      "comment": "Штаб",
      "payload": {
        "push": {
          "uri": "rtsp://admin:admin54321@192.168.254.12:554/Streaming/Channels/101",
          "streamName": "0124_3",
          "title": "A-7777-1",
          "comment": "Штаб",
          "OVZ": false
        },
        "rec": {
          "streamName": "0124_3",
          "uriRec": "",
          "limitSec": 0,
          "segmentSec": 1800,
          "title": "A-7777-1",
          "comment": "Штаб",
          "OVZ": false
        },
        "del": [
          "0124_3"
        ]
      }
    },
    ...
  },
  "unused_streams": [],
  "missing_auds": [],
  "avs_config": {
    "0124_1": {
      "ppe": "0124",
      "aud": "0000",
      "exam": [
        {
          "yd": "2022-05-23",
          "dy": "23-05-2022",
          "online": 1,
          "ovz": 1
        },
        ...
      ],
      "name": "A-0000-0",
      "id": 0,
      "stream_id": "0124_1",
      "zabx_id": "0124_0000_0_1",
      "comment": "Вход",
      "payload": {
        "push": {
          "uri": "rtsp://admin:admin54321@192.168.254.10:554/Streaming/Channels/101",
          "streamName": "0124_1",
          "title": "A-0000-0",
          "comment": "Вход",
          "OVZ": false
        },
        "rec": {
          "streamName": "0124_1",
          "uriRec": "",
          "limitSec": 0,
          "segmentSec": 1800,
          "title": "A-0000-0",
          "comment": "Вход",
          "OVZ": false
        },
        "del": [
          "0124_1"
        ]
      }
    },
    ...
  }
}
```
