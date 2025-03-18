from frictionless import Pipeline

pipeline = Pipeline.from_descriptor({
    "steps": [
        {"type": "table-normalize"},
        {
            "type": "field-add",
            "name": "cars",
            "formula": "I*4",
            "descriptor": {"type": "integer"},
        }
    ]
})

print(pipeline)
