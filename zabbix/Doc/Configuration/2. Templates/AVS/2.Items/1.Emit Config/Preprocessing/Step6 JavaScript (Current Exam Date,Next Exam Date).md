# Step6 JavaScript (Current Exam Date,Next Exam Date)

- [Step6 JavaScript (Current Exam Date,Next Exam Date)](#step6-javascript-current-exam-datenext-exam-date)
  - [Processor](#processor)
  - [Output Value](#output-value)

## Processor

```js
//=============================================================================
// CURRENT EXAM DATE; NEXT EXAM DATE
var ppe_config = JSON.parse(value);

function formatDate(date) {
  return date.getFullYear() + "-" + ("00" + (date.getMonth() + 1)).substr(-2) + "-" + ("00" + date.getDate()).substr(-2)
}

function formatDateDY(date) {
  return ("00" + date.getDate()).substr(-2) + "-"  + ("00" + (date.getMonth() + 1)).substr(-2) + "-" + date.getFullYear()
}

var exam_date_list = []

for (var date in ppe_config.involved_dates) {
  exam_date_list.push(date)
}

exam_date_list.sort()

var now = new Date("2022-06-07" + "T09:00:00.000+03:00")
//var now = new Date()

var exam_date = {
  days_next: -1,
  date_next: "",
  date_exam: []
}

for (var i in exam_date_list) {
  var curr_exam_date = new Date(exam_date_list[i] + "T00:00:00.000+03:00")
  var curr_date_diff = now.getTime() - curr_exam_date.getTime()

  if (curr_date_diff < 0) {
    exam_date["days_next"] = (Math.abs(curr_date_diff) - (Math.abs(curr_date_diff) % 86400000)) / 86400000 + 1;
    exam_date["date_next"] = formatDate(curr_exam_date);
    break;
  } else if (curr_date_diff < 86400000) {
    exam_date["date_exam"][0] = formatDate(curr_exam_date);
    exam_date["date_exam"][1] = formatDateDY(curr_exam_date);
  }
}

ppe_config["exam_date"] = exam_date;

return JSON.stringify(ppe_config);
```

## Output Value

```json
{
    "exam_date": {
        "days_next": 1,
        "date_next": "2022-06-07",
        "date_exam": ["2022-06-06", "07-06-2022"]
    },
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
