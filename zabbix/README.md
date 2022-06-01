# Zabbix

- [Zabbix](#zabbix)
  - [Templates](#templates)
    - [GIA Template. FCT Data](#gia-template-fct-data)
      - [Item: *Get Scheduler*](#item-get-scheduler)
      - [Item: *Get Involved Exam Days*](#item-get-involved-exam-days)
      - [Item: *Get Involved Cams Total*](#item-get-involved-cams-total)
      - [Item: *Get Involved Cams Tomorrow*](#item-get-involved-cams-tomorrow)
      - [Item: *Get Involved Cams Today*](#item-get-involved-cams-today)

## Templates

### GIA Template. FCT Data

#### Item: *Get Scheduler*

**Type:** *HTTP Agent*

- **URL:** `http://11.103.8.101:8080/api/calendar/all`

**RESULT:**

 ```json
 [
   {
     "Date": "2022-02-25",
     "PPECode": "0307",
     "AudienceCode": "0003",
     "Online": "0",
     "OVZ": "0",
     "MOCode": "44",
     "MO": "МО Щекинский район",
     "SubjectCode": "52",
     "Subject": "Математика",
     "Wave": "0"
   },
   ...
 ]
 ```

#### Item: *Get Involved Exam Days*

**Type:** *Dependent item*

**Master Item:** *Get Scheduler*

**Preprocessing:**

- **JSONPath:** `$.[?(@.PPECode=='{$AVSPPECODE}')]`
- **JavaScript:**

  ```js
  v = JSON.parse(value)
  const result = {}
  for (var i in v) {
    var dat = v[i]["Date"]
    var aud = v[i]["AudienceCode"]
    if (!result.hasOwnProperty(dat)) { result[dat] = {"0000": [1,0], "7777": [1, 0]} }
    result[dat][aud] = [Number(v[i]["Online"]), Number(v[i]["OVZ"])]
  }
  return JSON.stringify(result)
  ```

**RESULT:**

```json
[
  {
    "2022-02-25": {  // date
      "0307": {      // ppe
        "0000": [    // add aud entrance
          0,         // online
          0          // ovz
        ],
        "7777": [    // add aud HQ
          0,         // online
          0          // ovz
        ],
        "0003": [    // aud
          0,         // online
          0          // ovz
        ],
        ...
      },
      ...
    },
    ...
  }
]
```

#### Item: *Get Involved Cams Total*

**Type:** *Dependent item*

**Master Item:** *Get Scheduler*

**Preprocessing:**

- **JSONPath:** `$.[?(@.PPECode=='{$AVSPPECODE}')]`
- **JavaScript:**

  ```js
  v = JSON.parse(value)
  var s = ["0000", "7777"]
  for (var i in v) {
    if(s.indexOf(v[i]["AudienceCode"]) >= 0) continue;  
    s.push(v[i]["AudienceCode"])
  }
  return s.sort()
  ```

**RESULT:**

```json
[
  {
    "0307": [                           // ppe
        "0000", "7777", "0003", ...     // aud
    ],
    ...
  }
]
```

#### Item: *Get Involved Cams Tomorrow*

**Type:** *Dependent item*

**Master Item:** *Get Involved Exam Days*

**Preprocessing:**

- **JavaScript:**

  ```js
  var v = JSON.parse(value)
  var d = new Date(new Date().getTime() + 86400000)
  var s = d.getFullYear() + "-" + ("00" + (d.getMonth() + 1)).substr(-2) + "-" + ("00" + d.getDate()).substr(-2)
  if (v.hasOwnProperty(s)) {
    return JSON.stringify(v[s])
  }
  return "NO EXAM TOMORROW"
  ```

**RESULT:**

```json
[
  {
    "0000": [    // add aud entrance
      0,         // online
      0          // ovz
    ],
    "7777": [    // add aud HQ
      0,         // online
      0          // ovz
    ],
    "0003": [    // aud
      0,         // online
      0          // ovz
    ],
    ...
  }
]
```

#### Item: *Get Involved Cams Today*

**Type:** *Dependent item*

**Master Item:** *Get Involved Exam Days*

**Preprocessing:**

- **JavaScript:**

  ```js
  var v = JSON.parse(value)
  var d = new Date()
  var s = d.getFullYear() + "-" + ("00" + (d.getMonth() + 1)).substr(-2) + "-" + ("00" + d.getDate()).substr(-2)
  if (v.hasOwnProperty(s)) {
    return JSON.stringify(v[s])
  }
  return "NO EXAM TODAY"
  ```

**RESULT:**

```json
[
  {
    "0000": [    // add aud entrance
      0,         // online
      0          // ovz
    ],
    "7777": [    // add aud HQ
      0,         // online
      0          // ovz
    ],
    "0003": [    // aud
      0,         // online
      0          // ovz
    ],
    ...
  }
]
```
