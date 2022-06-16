# Step1. JSONPath (Filter by PPE)

- [Step1. JSONPath (Filter by PPE)](#step1-jsonpath-filter-by-ppe)
  - [Processor](#processor)
  - [Output Value](#output-value)

## Processor

```js
$.[?(@.PPECode=='{$GIA_PPE_CODE}')]
```

## Output Value

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
  {
    "Date": "2022-03-01",
    "PPECode": "0307",
    "AudienceCode": "0003",
    "Online": "0",
    "OVZ": "0",
    "MOCode": "44",
    "MO": "МО Щекинский район",
    "SubjectCode": "55",
    "Subject": "Информатика",
    "Wave": "0"
  },
  ...
]
```
