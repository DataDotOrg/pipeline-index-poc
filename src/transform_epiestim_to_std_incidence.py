import os
import sys

from frictionless import Resource, Pipeline, steps


def main():
    # define source resource
    _source = sys.argv[1]
    # _dest = sys.argv[2]
    source = Resource(_source)
    print(source.to_view())

    # create a pipeline
    pipeline = Pipeline(
        steps=[
            steps.table_normalize(),
            steps.table_recast(field_name="I"),
        ]
    )

    # apply the transform
    target = source.transform(pipeline)

    # printing resulting schema and data
    print(target.schema)
    print(target.to_view())
    # target.write(_dest) # write to file
    return os.EX_OK


if __name__ == "__main__":
    sys.exit(main())
