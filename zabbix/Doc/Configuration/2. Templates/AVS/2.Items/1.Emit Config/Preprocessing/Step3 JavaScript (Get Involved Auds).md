# Step3 JavaScript (Get Involved Auds)

- [Step3 JavaScript (Get Involved Auds)](#step3-javascript-get-involved-auds)
  - [Processor](#processor)
  - [Output Value](#output-value)

## Processor

```js
//=============================================================================
// GET INVOLVED AUDS
var involved_dates = JSON.parse(value);

var involved_auds = {};

for (var curr_date in involved_dates) {
    for (var curr_aud in involved_dates[curr_date]) {
        if (!involved_auds.hasOwnProperty(curr_aud)) involved_auds[curr_aud] = {}
        involved_auds[curr_aud][curr_date] = [curr_date.replace(/(\d{4})-(\d{2})-(\d{2})/, "$3-$2-$1")].concat(involved_dates[curr_date][curr_aud]);
    }
}

return JSON.stringify({
    "involved_dates": involved_dates,
    "involved_auds": involved_auds
})
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
    "involved_auds": {
        "0000": {
            "2022-03-12": ["07-06-2022", 1, 0]
            ...
        },
        ...
    }
}
```
