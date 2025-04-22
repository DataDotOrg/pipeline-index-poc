  - [x] I want to start off with the input file from `EpiEstim` and use it on the `EpiEstim` package.
  - [x] I want to start off with the input file from `EpiNow2` and use it on the `EpiEstim` package.
  - [x] Convert `EpiNow2` data to be compatible with `EpiEstim` tool.

# Notes

1. Start with a `csv` file.
2. Extract the schema only and exclude other descriptors.
    ```
    # to YAML 
    frictionless describe file.csv --yaml --type schema
    # to JSON 
    frictionless describe file.csv --json --type schema
    ```
   Otherwise, you will also get `name`, `type`, `path` etc.
3. The `transform_by_schema.py` module is used to transform the `EpiNow2` data to `EpiEstim` data.