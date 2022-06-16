# Step2 JavaScript (Get Involved Dates)

- [Step2 JavaScript (Get Involved Dates)](#step2-javascript-get-involved-dates)
  - [Processor](#processor)
  - [Output Value](#output-value)

## Processor

```js
//=============================================================================
// GET INVOLVED DATES
var scheduler = JSON.parse(value);

var involved_dates = {};

for (var i in scheduler) {
    var dat = scheduler[i]["Date"];
    var aud = scheduler[i]["AudienceCode"];
    if (!involved_dates.hasOwnProperty(dat)) { involved_dates[dat] = {"0000": [1,0], "7777": [1, 0]}; }
    involved_dates[dat][aud] = [Number(scheduler[i]["Online"]), Number(scheduler[i]["OVZ"])];
}

return JSON.stringify(involved_dates)
```

## Output Value

```json
{
    "2022-03-12": {
        "0000": [1,0],
        "7777": [1,0],
        "0003": [1,0],
        ...
    },
    ...
}
```
