# Common js scripts

- [Common js scripts](#common-js-scripts)
  - [Assign a value to a HOST "User Macro"](#assign-a-value-to-a-host-user-macro)
    - [1. Create request structure](#1-create-request-structure)
    - [2. Assign HOST Macro value](#2-assign-host-macro-value)

## Assign a value to a HOST "User Macro"

### 1. Create request structure

```json
// CREATE STRUCT FOR ASSIGN DATA TO HOST USER MACRO
{
    "data": {
        "{\$SOME_USER_MACRO}": {
            "value": "[]"               // default values type string (need to stringify objects)
        },
        "{\$ANOTHER_USER_MACRO}": {
            "value": "blabla"           // default values type string (need to stringify objects)
        },
        "{\$YET_ANOTHER_USER_MACRO}": {
            "value": ""                 // default values type string (need to stringify objects)
        },
    }
}
```

### 2. Assign HOST Macro value

```js
// ZBX API ASSIGN USER MACRO VALUE

// ===========================================================================
// GET TARGET USER HOST MACRO ID LIST
var result = JSON.parse(value);

var macroname_list = []
for (var i in result.data) macroname_list.push(i)

var request = new HttpRequest();
request.addHeader("Content-Type: application/json-rpc");
var data = {
    "jsonrpc":"2.0",
    "method":"usermacro.get",
    "params":{
        "output":["hostmacroid", "macro"],
        "hostids":"{$HOST_ID}",
        "filter": {
            "macro": macroname_list
        }
    },
    "auth":"{$GIA_ZABBIX_API_TOKEN}","id":1
}
var response = request.post("{$GIA_ZABBIX_API_URL}", JSON.stringify(data));

if (200 != request.getStatus() || JSON.parse(response).hasOwnProperty("error")) {
    result["err"] = {
        "reqv": "usermacro.get",
        "resp": JSON.parse(response)
    }
    return JSON.stringify(result);
} else {
    var r = JSON.parse(response)["result"]
    for (var i in r) {
        result["data"][r[i]["macro"]]["hostmacroid"] = r[i]["hostmacroid"]
    }
}

// ===========================================================================
// UPDATE TARGET USER HOST MACRO LIST
for (var i in result["data"]) {
    var request = new HttpRequest();
    request.addHeader("Content-Type: application/json-rpc");
    var data = {
        "jsonrpc":"2.0",
        "method":"usermacro.update",
        "params": result["data"][i],
        "auth":"{$GIA_ZABBIX_API_TOKEN}","id":1
    }

    var response = request.post("{$GIA_ZABBIX_API_URL}", JSON.stringify(data));
    if (200 != request.getStatus() || JSON.parse(response).hasOwnProperty("error")) {
        if(!result.hasOwnProperty("err")) {
            result["err"] = {
                "reqv": "usermacro.update",
                "resp": {}
            }
        }
        result["err"]["resp"][i] = (response != "") ? JSON.parse(response) : response
    }
}
return JSON.stringify(result)
```
